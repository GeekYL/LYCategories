//
//  NSData+LYAdd.m
//  LYCategories
//
//  Created by Liu Y on 16/4/3.
//  Copyright © 2016年 DeveloperLY. All rights reserved.
//

#import "NSData+LYAdd.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
#import <zlib.h>
#import <dlfcn.h>
#import "LYCategoriesMacro.h"

LYSYNTH_DUMMY_CLASS(NSData_LYAdd)

@implementation NSData (LYAdd)

- (NSString *)md5 {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

- (NSString *)sha1 {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)sha256 {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)sha384 {
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)sha512 {
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)base64Encode {
    NSString *base64String = [GTMBase64 encodeBase64Data:self];
    return base64String;
}

- (NSString *)base64Decode {
    NSString *base64String = [GTMBase64 decodeBase64Data:self];
    return base64String;
}

- (NSString *)encryptWithKey:(NSString *)key {
    return [self encrypt:self encryptOrDecrypt:kCCEncrypt key:key];
}

- (NSString *)decryptWithKey:(NSString *)key {
    return [self encrypt:self encryptOrDecrypt:kCCDecrypt key:key];
}

/**
 *  加密或解密
 *
 *  @param lsdata           需要加密或解密的字符串
 *  @param encryptOperation kCCDecrypt 解密 kCCEncrypt 加密
 *  @param key              加密解密需要的key
 *
 *  @return 返回加密或解密之后得到的字符串
 */
- (NSString *)encrypt:(NSData *)lsdata encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key {
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt) {
        plainTextBufferSize = [lsdata length];
        vplainText = [lsdata bytes];
    } else {
        plainTextBufferSize = [lsdata length];
        vplainText = (const void *)[lsdata bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"shuai";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt) {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] ;
    } else {
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;
}

#pragma mark - Gzip

static void *ly_libzOpen() {
    static void *libz;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libz = dlopen("/usr/lib/libz.dylib", RTLD_LAZY);
    });
    return libz;
}

- (NSData *)ly_gzippedDataWithCompressionLevel:(float)level {
    if (self.length == 0 || [self ly_isGzippedData]) {
        return self;
    }
    
    void *libz = ly_libzOpen();
    int (*deflateInit2_)(z_streamp, int, int, int, int, int, const char *, int) =
    (int (*)(z_streamp, int, int, int, int, int, const char *, int))dlsym(libz, "deflateInit2_");
    int (*deflate)(z_streamp, int) = (int (*)(z_streamp, int))dlsym(libz, "deflate");
    int (*deflateEnd)(z_streamp) = (int (*)(z_streamp))dlsym(libz, "deflateEnd");
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)(void *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    static const NSUInteger ChunkSize = 16384;
    
    NSMutableData *output = nil;
    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }
    
    return output;
}

- (NSData *)ly_gzippedData {
    return [self ly_gzippedDataWithCompressionLevel:-1.0f];
}

- (NSData *)ly_gunzippedData {
    if (self.length == 0 || ![self ly_isGzippedData]) {
        return self;
    }
    
    void *libz = ly_libzOpen();
    int (*inflateInit2_)(z_streamp, int, const char *, int) =
    (int (*)(z_streamp, int, const char *, int))dlsym(libz, "inflateInit2_");
    int (*inflate)(z_streamp, int) = (int (*)(z_streamp, int))dlsym(libz, "inflate");
    int (*inflateEnd)(z_streamp) = (int (*)(z_streamp))dlsym(libz, "inflateEnd");
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK) {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:self.length * 2];
        while (status == Z_OK) {
            if (stream.total_out >= output.length)
            {
                output.length += self.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK) {
            if (status == Z_STREAM_END) {
                output.length = stream.total_out;
            }
        }
    }
    
    return output;
}

- (BOOL)ly_isGzippedData {
    const UInt8 *bytes = (const UInt8 *)self.bytes;
    return (self.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

#pragma mark - APNSToken
- (NSString *)ly_APNSTokenDataToString {
    return [[[[self description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
