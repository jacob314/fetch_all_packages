//
//  Participant.hpp
//  chatboard-core
//
//  Created by mac zhang on 30/09/2017.
//  Copyright © 2017 mac zhang. All rights reserved.
//

#ifndef Participant_hpp
#define Participant_hpp
#include "core/data/JsonData.hpp"
#include <string>



namespace CBCore
{
    using namespace std;
    class Participant
    {
    public:
        Participant();
        virtual ~Participant();

		const std::string& getIdentify() const;
		const std::string& getName() const;
		const std::string& getAvatar() const;
        const std::string& getSessionId() const;
        const int& getPrivilege() const;
        const int& getIsOnline() const;
        void setIsOnline(int isOnline);
        void setMicStatus(bool status);
        bool getMicStatus();
        void setSessionId(std::string _sessionId);
        bool loadFromJson(JsonData & _data);
        void setIdentify(const std::string& identity);
    protected:
        std::string m_identify;
        std::string m_name;
        std::string m_avatar;
        std::string m_sessionId;
        int    m_pribilege;
        int    m_isOnline;
   public:
        bool   m_isMic;
    };
} // namespace CBCore
#endif /* Participant_hpp */
