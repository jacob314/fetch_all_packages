import 'package:test/test.dart';
import 'package:flutter_aws_rest/flutter_aws_rest.dart';

void main() {

  final creds = new AwsCredentials(
      "AKIAIV4CQ4KNRV6FXA3Q", "0dAnB8AKJel30L8wz2IJEAIIMTIPDyz1pD2DDlmD");
  final scope = new AwsScope("ap-south-1", 's3');
  final signer = new RequestSigner(creds, scope);
  final awsClient = new AwsClient(signer);
  final bucketApi = new S3BucketApi("restra", "ap-south-1", awsClient);
  bucketApi.listBucket().then((ListBucketResult results) {
    print('Objects in bucket:');
    results.contents.forEach((content) => print(content.key));
  });
}
