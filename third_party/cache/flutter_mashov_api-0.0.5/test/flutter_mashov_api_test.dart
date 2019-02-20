import 'dart:io';

/// ignore_for_file: unused_import
import 'package:flutter_mashov_api/src/controller/api_controller.dart';
import 'package:flutter_mashov_api/src/controller/cookie_manager.dart';
import 'package:flutter_mashov_api/src/controller/cookie_manager_impl.dart';
import 'package:flutter_mashov_api/src/controller/request_controller.dart';
import 'package:flutter_mashov_api/src/controller/request_controller_impl.dart';
import 'package:flutter_mashov_api/src/models/attachment.dart';
import 'package:flutter_mashov_api/src/models/behave_event.dart';
import 'package:flutter_mashov_api/src/models/contact.dart';
import 'package:flutter_mashov_api/src/models/conversation.dart';
import 'package:flutter_mashov_api/src/models/grade.dart';
import 'package:flutter_mashov_api/src/models/group.dart';
import 'package:flutter_mashov_api/src/models/homework.dart';
import 'package:flutter_mashov_api/src/models/lesson.dart';
import 'package:flutter_mashov_api/src/models/login.dart';
import 'package:flutter_mashov_api/src/models/maakav.dart';
import 'package:flutter_mashov_api/src/models/message.dart';
import 'package:flutter_mashov_api/src/models/message_title.dart';
import 'package:flutter_mashov_api/src/models/messages_count.dart';
import 'package:flutter_mashov_api/src/models/result.dart';
import 'package:flutter_mashov_api/src/models/school.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:test_api/test_api.dart';



void main() async {
  setInjector();
  await getSecrets();
  ApiController controller = Injector.getInjector().get(key: "ApiController");
  test("Testing Api Controller", () async {
    Result<List<School>> schoolsR = await controller.getSchools();
    checkSuccess(schoolsR);
    var schools = schoolsR.value;
    var school = schools.firstWhere((school) => school.id == schoolId);
    Result<Login> loginR = await controller.login(
        school, userName, password, year);
    checkSuccess(loginR);
    Login login = loginR.value;
    String userId = login.students.first.id;
    Result<List<Maakav>> maakavR = await controller.getMaakav(userId);
    checkSuccess(maakavR);
    List<Maakav> maakavReports = maakavR.value;
    Attachment maakavAttachment = maakavReports.first.attachments.first;
    File a = new File(maakavAttachment.name);
    await controller.getMaakavAttachment(maakavReports.first.id, userId,
        maakavAttachment.id, maakavAttachment.id, a);

    ///separateLog();
    ///grades test:
    /*List<Grade> grades = await src.controller.getGrades(userId);

    print("length is${grades.length}");
    for(Grade g in grades) {
      print("grade is ${g.toString()}");
    }*/

    ///separateLog();

    ///behave events test
    /*List<BehaveEvent> events = await src.controller.getBehaveEvents(userId);
    print("behave events length is ${events.length}");
    for(BehaveEvent e in events) {
      print("event is ${e.toString()}");
    }*/

    ///messages test:
    ///    MessagesCount count = await src.controller.getMessagesCount();
    ///    print(count.toString());
    ///    List<Conversation> messages = await src.controller.getMessages(0);
    ///    for(Conversation conversation in messages) {
    ///      print(conversation.messages.first.subject);
    ///    }
    ///    String messageId = messages.firstWhere((c) => c.hasAttachments).messages.first.messageId;
    ///    print("trying to get a message with id $messageId");
    ///    Message message = await src.controller.getMessage(messageId);
    ///    print("has attachment with id ${message.attachments.first.id} and name ${message.attachments.first.name}");
    ///    ///let's try to get the attachment
    ///    Attachment attachment = message.attachments.first;
    ///    src.controller.getAttachment(messageId, attachment.id, attachment.name, File(attachment.name));

    ///timetable test:
    ///    List<Lesson> timetable = await src.controller.getTimeTable(userId);
    ///    print("there are ${timetable.length} lessons.");
    ///    timetable.sort((l1, l2) {
    ///      return (20*l1.day + l1.hour) - (20*l2.day + l2.hour);
    ///    });
    ///    timetable.forEach((l) => print(l.toString()));

    ///Alfon test:
    ///    List<Group> groups = await src.controller.getGroups(userId);
    ///    print("groups length is ${groups.length}");
    ///    for(Group g in groups) {
    ///      print(g.toString());
    ///    }
    ///    separateLog();
    ///    List<Contact> classContacts = await src.controller.getContacts(userId, "-1");
    ///    List<Contact> someGroupContacts = await src.controller.getContacts(userId, groups.firstWhere((group) => group.id.toString() != "-1").id.toString());
    ///    print("${classContacts.length} class contacts");
    ///    print("${someGroupContacts.length} some group contacts");
    ///    separateLog();
    ///    classContacts.forEach((contact) => print(contact.toString()));
    ///    separateLog();
    ///    someGroupContacts.forEach((contact) => print(contact.toString()));

    ///  src.controller.getPicture(userId, File("picture.jpg"));

    ///homework test:
    ///    List<Homework> homework = await src.controller.getHomework(userId);
    ///    for(Homework work in homework) {
    ///      print("${work.subject}(${work.date.toIso8601String()}): ${work.message}");
    ///    }
  });
}

String userName = "";
String password = "";
const int year = 2019;
int schoolId = 123456;

void separateLog() {
  print("\n\n\n\n\n");
}

///I've written a file called "secrets.txt" in the root folder that contains
///my credentials in the following format:
///username:password:schoolId
///if you wish to test, just create the same file, with this format,
///and the following function should work.
///otherwise, just change the above variables and comment-out the call to getSecrets().
///make sure you don't upload your credentials!
Future<bool> getSecrets() async {
  File secrets = new File("secrets.txt");
  return secrets.readAsString().then((contents) {
    List<String> values = contents.split(":");
    userName = values.first;
    password = values[1];
    schoolId = int.parse(values.last);
  }).then((a) => true);
}

void setInjector() {
  Injector inject = Injector.getInjector();
  inject.map<CookieManager>((i) => CookieManagerImpl(), key: "CookieManager");
  inject.map<RequestController>((i) => RequestControllerImpl(),
      key: "RequestController");
  inject.map<ApiController>((i) => ApiController(), key: "ApiController");
}

void checkSuccess(Result r) {
  if (!r.isSuccess) {
    throw Exception("on checkSuccess: " + r.exception.toString());
  }
}
