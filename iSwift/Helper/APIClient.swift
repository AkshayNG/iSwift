//
//  APIClient.swift
//  All List
//
//  Created by Amol Bapat on 30/11/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import Foundation


class APIClient: NSObject
{
    static func asynchronousRequest(url:URL?,
                                    method:String?,
                                    body:Data?,
                                    headers:NSDictionary?,
                                    completion: @escaping (_ httpData:Data?, _ httpResponse: URLResponse?, _ httpError:Error?) -> Void)
    {
        
        precondition(url != nil, "URL should not be nil")
        precondition(method != nil, "Method should not be nil")
        
        let reachability = Reachability(hostName: "www.google.com")
        if (reachability?.isReachable)!
        {
            let request = NSMutableURLRequest.init()
            
            request.url = url
            request.httpMethod = method!
            
            if(body != nil)
            {
                request.httpBody = body
            }
            
            if(headers != nil)
            {
                for field in (headers?.allKeys)! {
                    request.setValue(headers?.value(forKey: field as! String) as! String?, forHTTPHeaderField: field as! String)
                }
            }
            
            URLSession.shared .dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                completion(data,response,error)
                
            }).resume()
        }
        else
        {
            let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedDescriptionKey : "Please check internet connection"])
            
            completion(nil, nil, error)
        }
    }
}





/************ Synchronous request
 
 If you set a NSURLSession's delegation queue yourself make sure you do not call your method in the same queue since it will block it.
 
 By default NSURLSession ALWAYS creates a new delegateQueue during initialisation. If you set a delegation queue yourself, of course you should not block it.


+(NSDictionary*)synchronousRequestWithURL:(NSURL*)url
method:(NSString*)method
body:(NSData*)body
headerFields:(NSDictionary*)headers
{
    
    __block NSDictionary* jsonResponse;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:method];
    [request setHTTPBody:body];
    
    if(headers != nil)
    {
        for (NSString *field in [headers allKeys])
        {
            [request setValue:[headers valueForKey:field] forHTTPHeaderField:field];
        }
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
        
        if(data!=nil)
        [tempDict setObject:data forKey:@"data"];
        
        if(error!=nil)
        [tempDict setObject:error forKey:@"error"];
        
        if(httpResponse!=nil)
        [tempDict setObject:httpResponse forKey:@"httpResponse"];
        
        jsonResponse = tempDict;
        
        tempDict = nil;
        
        dispatch_semaphore_signal(semaphore); // Line 2
        
        }];
    
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // Line 3
    
    return jsonResponse;
}
*/
