import ballerina/test;
import ballerina/file;
import ballerina/log;

string filepath = "test.txt";
@test:BeforeEach
public function initT() {
    file:Error? create = file:create(filepath);
    if (create is error) {
        log:printError("Error while creating the file", 'error = create, stackstrace = create.stackTrace().callStack);
    }
}

@test:Config {
    enable: true
}
public function testSmallStringContent() {
    string content = "Hello Swan Lake";
    error? fileWriteStringResult = fileWriteString(filepath, content);
    if (fileWriteStringResult is error) {
        log:printError("Error while writing content to the file", 'error = fileWriteStringResult, stackstrace = fileWriteStringResult.stackTrace().callStack);
        test:assertFail("Error while writing content to the file");
    } else {
        log:printInfo("File write operation is successful.", filename = filepath, content = content);
    }

    string|error fileReadStringResult = fileReadString(filepath);
    if (fileReadStringResult is error) {
        log:printError("Error while reading content from the file", 'error = fileReadStringResult, stackstrace = fileReadStringResult.stackTrace().callStack);
        test:assertFail("Error while reading content from the file");
    } else {
        log:printInfo("File read operation is successful.", filename = filepath, content = fileReadStringResult);
    }
    file:Error? remove = file:remove(filepath);
    if (remove is error) {

    }
}


@test:AfterEach
public function cleanUp() {
    file:Error? remove = file:remove(filepath);
    if (remove is error) {
        log:printError("Error while deleting the file", 'error = remove, stackstrace = remove.stackTrace().callStack);
    }
}