//
//  CBBaseRender.m
//  Pods-Runner
//
//  Created by xuxinyuan on 2018/11/1.
//

#import "CBBaseRender.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>

#define USE_16bit 0

#define USE_MSAA 1

#if USE_16bit
#define colorFormatLayer kEAGLColorFormatRGB565
#define colorFormat GL_RGB565
#else
#define colorFormatLayer kEAGLColorFormatRGBA8
#define colorFormat GL_RGBA8
#endif

@interface CBBaseRender()
{
    int _width;
    int _height;
}

@property (copy, nonatomic) void(^onNewFrame)(void);
@property (nonatomic,assign) CBScreenMode screenMode;


@property (nonatomic) GLuint frameBuffer;
@property (nonatomic) GLuint depthBuffer;
@property (nonatomic) CVPixelBufferRef target;
@property (nonatomic) CVOpenGLESTextureCacheRef textureCache;
@property (nonatomic) CVOpenGLESTextureRef texture;
@property (nonatomic) CGSize renderSize;

@property (nonatomic,assign)BOOL isUpdate;

@end

@implementation CBBaseRender

-(instancetype)initWithSize:(CGSize)size andScreenMode:(CBScreenMode)mode andName:(NSString *)name onNewFrame:(void(^)(void))onNewFrame;
{
    if(self = [super init])
    {
        _name = name;
        self.onNewFrame = onNewFrame;
        self.screenMode = mode;
        self.renderSize = size;
        _isUpdate = YES;
        
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        thread.name = @"OpenGLRender";
        [thread start];
    }
    return self;
}

-(void)run
{
    [self initGL];
    
    while (_isUpdate)
    {
        CFTimeInterval loopStart = CACurrentMediaTime();
        
        [[ChatboardInterface sharedChatboardInterfaceManager] updateGL:_name];
        
        glFlush();
        
        dispatch_async(dispatch_get_main_queue(), self.onNewFrame);
        
        CFTimeInterval waitDelta = 0.016 - (CACurrentMediaTime() - loopStart);
        if (waitDelta > 0) {
            [NSThread sleepForTimeInterval:waitDelta];
        }
    }
}

#pragma mark - FlutterTexture

- (_Nullable CVPixelBufferRef)copyPixelBuffer
{
    CVBufferRetain(_target);
    return _target;
}

-(void)createScreen:(NSString *)name
{
    [[ChatboardInterface sharedChatboardInterfaceManager] createScreen:self.screenMode withName:_name withWidth:self.renderSize.width andHeight:self.renderSize.height];
    [[ChatboardInterface sharedChatboardInterfaceManager] setIsFilp:true];
}

- (void)removeFromSuperview
{
    [self close];
    _isUpdate = NO;
    if([_name isEqualToString:@"main"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] destroyGL];
        
        [EAGLContext setCurrentContext:nil];
        
        context = nil;
    }
}

-(NSString *)identify
{
    return _name;
}

-(void)close
{
    [EAGLContext setCurrentContext:context];
    [self releasOpenGL];
    [[ChatboardInterface sharedChatboardInterfaceManager] closeScreen:_name];
}

-(void)releasOpenGL
{
    CVPixelBufferRelease(_target);
    CVOpenGLESTextureCacheFlush(_textureCache, 0);
    if (_depthBuffer)
    {
        glDeleteRenderbuffers(1, &_depthBuffer);
        _depthBuffer = 0;
    }
    if (_frameBuffer)
    {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
}

- (NSString *)uiImageFromPixelBuffer:(CVPixelBufferRef)p
{
    CIImage* ciImage = [CIImage imageWithCVPixelBuffer:p];
    
    CIContext* context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    
    CGRect rect = CGRectMake(0, 0, CVPixelBufferGetWidth(p), CVPixelBufferGetHeight(p));
    
    CGImageRef videoImage = [context createCGImage:ciImage fromRect:rect];
    
    UIImage* image = [UIImage imageWithCGImage:videoImage];
    
    CGImageRelease(videoImage);
    
    if([UIImagePNGRepresentation(image) writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache/screenshot.jpg"] atomically:YES])
    {
        return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache/screenshot.jpg"];
    }
    return @"";
}

-(NSString *)screenshot
{
    return [self uiImageFromPixelBuffer:_target];
}

- (void)initGL {
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    [EAGLContext setCurrentContext:context];
    [self createCVBufferWithSize:_renderSize withRenderTarget:&_target withTextureOut:&_texture];
    
    glBindTexture(CVOpenGLESTextureGetTarget(_texture), CVOpenGLESTextureGetName(_texture));
    
    glTexImage2D(GL_TEXTURE_2D,
                 0, GL_RGBA,
                 _renderSize.width, _renderSize.height,
                 0, GL_RGBA,
                 GL_UNSIGNED_BYTE, NULL);
    
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _renderSize.width, _renderSize.height);
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_texture), 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    
    [[ChatboardInterface sharedChatboardInterfaceManager] prepareGL:CBRenderOpenGLES3];
    [self createScreen:_name];
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)createCVBufferWithSize:(CGSize)size
              withRenderTarget:(CVPixelBufferRef *)target
                withTextureOut:(CVOpenGLESTextureRef *)texture {
    
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, context, NULL, &_textureCache);
    
    if (err) return;
    
    CFDictionaryRef empty;
    CFMutableDictionaryRef attrs;
    empty = CFDictionaryCreate(kCFAllocatorDefault,
                               NULL,
                               NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault, 1,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height,
                        kCVPixelFormatType_32BGRA, attrs, target);
    
    CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                 _textureCache,
                                                 *target,
                                                 NULL, // texture attributes
                                                 GL_TEXTURE_2D,
                                                 GL_RGBA, // opengl format
                                                 size.width,
                                                 size.height,
                                                 GL_BGRA, // native iOS format
                                                 GL_UNSIGNED_BYTE,
                                                 0,
                                                 texture);
    
    CFRelease(empty);
    CFRelease(attrs);
}

@end
