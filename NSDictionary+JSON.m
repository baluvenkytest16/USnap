/*
 * Copyright (C) 2015 - Cognizant Technology Solutions.
 * This file is a part of OneMobileStudio
 * Licensed under the OneMobileStudio, Cognizant Technology Solutions,
 * Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *  http://www.cognizant.com/
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import "NSDictionary+JSON.h"

@implementation NSDictionary(JSONCategory)

+(id)dictionaryWithContentsOfData:(NSData *)data WithOptions:(NSJSONReadingOptions)
option
{
	/*
	 1.give the json data from web service as input
	 2.using data and option create dictionary using JSON Serialization class
	 3.return the dictionary
	 */
    
    __autoreleasing NSError *error=nil;
    id result;
    @try{
    result = [NSJSONSerialization JSONObjectWithData:data
                                                options:option error:&error];
    }
    @catch (NSException *e)
    {
        NSString *str = [NSString stringWithFormat:@"\n%@ - %@", [self class],[e description]];
    }
    @finally{
    if (error != nil) {
		
        NSLog(@"NSDictionaryJSONCategory::%@",error);
		return nil;
    }
        return result;
    }
}

-(id)toJsonWithOptions:(NSJSONWritingOptions)options
{
    
    /*
	 
     1.using dictionary  and option create json data using JSON Serialization class
     2.return the json data object
     */
	
    if ([NSJSONSerialization isValidJSONObject:self ])
    {
        id result;
        __autoreleasing NSError* error = nil;
        @try{
         result = [NSJSONSerialization dataWithJSONObject:self
                                                    options:options error:&error];
        
        }
        @catch (NSException *e)
        {
            NSString *str = [NSString stringWithFormat:@"\n%@ - %@", [self class],[e description]];
        }
        @finally{
        
        if (error != nil) return nil;
        return result;
        }
    }
    return nil;
	
}
@end
