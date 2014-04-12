//
//  BHLLCDataHelper.h
//  ShopingCar
//
//  Created by liaolongcheng on 14-3-21.
//  Copyright (c) 2014年 liaolongcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestSuccess)(NSURLConnection *connection, NSURLResponse *response, NSData *ressponseData);
typedef void(^requestError)(NSURLConnection *connection,NSURLResponse *response,NSError *urlError);

@interface BHLLCDataHelper : NSObject<NSURLConnectionDataDelegate>

+(void) getDataWithUrl:(NSString *)url urlSuccess:(requestSuccess) success urlError:(requestError) error;

@end


@interface connectionDelegate : NSObject


-(id)initWithUrl:(NSString *) url success:(requestSuccess) success error:(requestError) error;

-(void) requestData;

@end
