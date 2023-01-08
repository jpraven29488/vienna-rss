//
//  Criteria+SQL.h
//  Vienna
//
//  Copyright 2022 Tassilo Karge
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import "Vienna-Swift.h" //ATTENTION this only works if not included in bridging header! Workaround for that is to redeclare the functions in swift

NS_ASSUME_NONNULL_BEGIN

@interface CriteriaTree (SQL)

-(NSString *)toSQLForDatabase:(Database *)database;

@end

NS_ASSUME_NONNULL_END
