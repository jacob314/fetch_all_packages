#pragma once

#include "define.h"
#include <string>
#include <vector>
#include <functional>

#if defined(_WIN32)
#define EASYWEBRTC_CALL __stdcall
#if defined(EASYWEBRTC_EXPORT)
#define EASYWEBRTC_API __declspec(dllexport)
#else
#define EASYWEBRTC_API __declspec(dllimport)
#endif
#elif defined(__APPLE__)
#define EASYWEBRTC_API __attribute__((visibility("default")))
#define EASYWEBRTC_CALL
#elif defined(__ANDROID__) || defined(__linux__)
#define EASYWEBRTC_API __attribute__((visibility("default")))
#define EASYWEBRTC_CALL
#endif

namespace Native
{
	//typedef void(EASYWEBRTC_CALL *OnRenderVideoCallback)(uint8_t * frame_buffer, uint32_t w, uint32_t h);
	//typedef void(EASYWEBRTC_CALL *OnRenderVideoCallbackYUV)(uint8_t* y, uint8_t* u, uint8_t* v, uint32_t w, uint32_t h);
//	typedef void(EASYWEBRTC_CALL *NotifyCallback)(const char* notify);
	
	class EASYWEBRTC_API EasyWebrtc
	{
	public:
		static EasyWebrtc* GetInstance()
		{
			return &ewInstance;
		}

		int init(int devicetype, std::string accountId,
			std::string sessionId,
			const std::string  host,
			const std::string  port,
			const std::string  target,
			std::function<void(const char* notify)> notifyCallback); // 初始化
		static std::vector<std::pair<std::string, std::string>> getLocalVideoDevices(); // 取得摄像头列表
		static std::vector<int> getDesktopList(); // 取得桌面列表
		void switchRole(int devicetype, int mode); // 切换角色
		void selectVideoSource(int devicetype, int index); // 选择视频源
		void setScreenResolution(int devicetype, int scrWidth, int scrHeight);
		void setTrackEnable(int devicetype, std::string name, int type, bool enable); // 音视频使能
		bool setVideoCallbackRGB(int devicetype, std::string userName, std::string streamLabel, int trackIndex, std::function<void(uint8_t * frame_buffer, uint32_t w, uint32_t h)> cb); // 设置视频回调
		bool setVideoCallbackYUV(int devicetype, std::string userName, std::string streamLabel, int trackIndex, std::function<void(uint8_t* y, uint8_t* u, uint8_t* v, uint32_t w, uint32_t h)> cb);
		void joinRoom(int devicetype, std::string room); // 加入room
		void leaveRoom(int devicetype); // 离开room

	private:
		EasyWebrtc();
		~EasyWebrtc();

	private:
		static EasyWebrtc  ewInstance;
		void* pEasyWebrtcVideo;
		void* pEasyWebrtcDesktop;
	};

	
}

