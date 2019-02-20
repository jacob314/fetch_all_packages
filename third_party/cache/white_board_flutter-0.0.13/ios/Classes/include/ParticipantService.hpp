#ifndef PARTICIPANTSERVICE_HPP
#define PARTICIPANTSERVICE_HPP
#include "Participant.hpp"
#include <map>
#include <string>
#include <mutex>
#include <memory>
#include <functional>
#include "core/data/JsonData.hpp"

namespace CBCore
{
    using namespace std;
    enum class ParticipantEvent
    {
        Invited,
        Joined,
        Leave,
        MicOn,
        MicOff,
        VoiceOn,
        VoiceOff,
        VideoOn,
        VideoOff,
        KickOut
    };
    //service for participant management and event dispatcher
    class ParticipantService
    {
    public:
        ParticipantService();
        ~ParticipantService();
    public:
        static ParticipantService * instance();
    protected:
        map<string,shared_ptr<Participant>> m_participantList;
        std::function<void(string,ParticipantEvent,string)> m_eventCallback;
    public:
        void addParticipant(shared_ptr<Participant> _participant);
        void addParticipantFromJson(json & _data);
        void updateParticipant(string _participantId,ParticipantEvent _event,string _sessionId);
        void removeParticipant(string _participantId);
        void removeParticipantFromJson(json & _data);
        string isExistByUrl(const std::string _url);
        string getAvatarPath(const string & _accountId);
        shared_ptr<Participant> getParticipantByaccountId(string _participantId);
        shared_ptr<Participant> getParticipantBySessionId(string _sessionId);
        bool loadFromJson(json & _data);
        void setParticipantEventFunc(std::function<void(string,ParticipantEvent,string)> _callback);
        mutex m_participantLock;

    };
}
#endif // PARTICIPANTSERVICE_HPP
