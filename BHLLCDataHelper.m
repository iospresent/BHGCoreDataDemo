//
//  BHLLCDataHelper.m
//  ShopingCar
//
//  Created by liaolongcheng on 14-3-21.
//  Copyright (c) 2014年 liaolongcheng. All rights reserved.
//

#import "BHLLCDataHelper.h"

@implementation BHLLCDataHelper
{
    
}

+(void) getDataWithUrl:(NSString *)url urlSuccess:(requestSuccess) success urlError:(requestError) error
{
    connectionDelegate *de=[[connectionDelegate alloc] initWithUrl:url success:success error:error];
    [de requestData];
}



@end

@implementation connectionDelegate
{
    NSURLResponse *_response;
    requestSuccess _success;
    requestError _error;
    NSString *_url;
    NSMutableData *_mData;

}

-(id)initWithUrl:(NSString *) url success:(requestSuccess) success error:(requestError) error
{
    self=[super init];
    if (self) {
        _success=[success copy];
        _error=[error copy];
        _url=url;
        _mData=[NSMutableData data];
    }
    return self;
}

-(void)requestData
{
    NSURL *requestUrl=[NSURL URLWithString:_url];
    NSURLRequest *request=[NSURLRequest requestWithURL:requestUrl];
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response=response;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    _success(connection,_response,_mData);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error(connection,_response,error);
}

@end
