//
//  InterfaceDefine.hpp
//  ChatboardCore
//
//  Created by mac zhang on 01/03/2018.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef InterfaceDefine_hpp
#define InterfaceDefine_hpp

namespace CBIO
{
    enum class RenderType { OpenGL, OpenGLES2,OpenGLES3, Skia };
    enum class ScreenType {Normal,Mini,Assistant,Video};
    enum class SyncStatus {Downloading,Uploading,Downloaded,Uploaded,ReadyForDownload,Failed,Refused,Waiting,Converting};
    enum class MenuCommand {Delete,FullScreen};
    enum class PanelCommand{Config,PageUp,PageDown,EnableVideo,DisableVideo};
    enum class WidgetType { Office,Image,Memo,Video,Text};
    
    enum class TextEventType{
        TextActivity,
        TextGenerateImage,
        TextFontChange
    };
    enum class InputMode
    {
        Draw,
        Erase,
        Select,
        Zoom
    };
}
#endif /* InterfaceDefine_hpp */
