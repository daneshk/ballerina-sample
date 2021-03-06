import ballerina/crypto;
import ballerina/io;
import ballerina/random;

byte[16] rsaKeyArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

# Module init function.
# 
# + return - an error if we encounter an issue while decoding the private key
function init() returns error? {
    foreach var i in 0 ... 15 {
        rsaKeyArray[i] = <byte>(check random:createIntInRange(0, 255));
    }
}

# Read the entire file encrypted content, decrypted it and returns as a `string`.
#
# + path - The path of the file.
# + return - The entire file content as a string or an error.  
public function fileReadString(string path) returns string|error {
    byte[] fileReadResult = check io:fileReadBytes(path);
    byte[] decryptRsaEcb = check crypto:decryptAesEcb(fileReadResult, rsaKeyArray);
    return string:fromBytes(decryptRsaEcb);
}


# Write a string content to a file in entryped form.
#
# + path - The path of the file    
# + content - String content to write    
# + option - To indicate whether to overwrite or append the given content  
# + return - Return Value Description
public function fileWriteString(string path, string content, io:FileWriteOption option = io:OVERWRITE) returns error? {
    byte[] encryptRsaEcb = check crypto:encryptAesEcb(content.toBytes(), rsaKeyArray);
    check io:fileWriteBytes(path, encryptRsaEcb, option);
}
