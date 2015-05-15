//
//  main.m
//  RealmImportForShift
//
//  Created by 平塚 俊輔 on 2015/05/14.
//  Copyright (c) 2015年 平塚 俊輔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Area.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        
        
        [RLMRealm setSchemaVersion:1
                    forRealmAtPath:[RLMRealm defaultRealmPath]
                withMigrationBlock:^(RLMMigration *migration, NSUInteger oldSchemaVersion) {
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < 1) {
                        // The enumerateObjects:block: method iterates
                        // over every 'Person' object stored in the Realm file
                        [migration enumerateObjects:Area.className
                                              block:^(RLMObject *oldObject, RLMObject *newObject) {
                                                  
                                                  // combine name fields into a single field
                                                  newObject[@"prefs"] = nil;
                                              }];
                        
                        [migration enumerateObjects:Pref.className
                                              block:^(RLMObject *oldObject, RLMObject *newObject) {
                                                  
                                                  // combine name fields into a single field
                                                  newObject[@"PrefCode"] = nil;
                                                  newObject[@"PrefName"] = nil;
                                                  newObject[@"id"] = nil;
                                                  newObject[@"area"] = nil;
                                              }];
                    }
                }];

        
        
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        // Import JSON
        NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonFilePath];
        NSError *error = nil;
        NSArray *areaDicts = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:0
                                                               error:&error];
        if (error) {
            NSLog(@"There was an error reading the JSON file: %@", error.localizedDescription);
            return 1;
        }
        
        
        // Add Person objects in realm for every person dictionary in JSON array
        int i=1;
        int j=1;
        Area *aobj = nil;
        RLMArray *prefAry = [[RLMArray alloc] initWithObjectClassName:@"Pref"];
        NSString *tmpCode = nil;
        for (NSDictionary *areaDict in areaDicts) {
            
            Pref *pobj = [[Pref alloc] init];
            
            
            if (tmpCode != areaDict[@"AreaCode"] && i != 1) {
                
                
                aobj.prefs = prefAry;
                [realm addObject:aobj];
                i++;
                
                aobj = [[Area alloc] init];
                aobj.id = i;
                aobj.AreaCode = areaDict[@"AreaCode"];
                aobj.AreaName = areaDict[@"AreaName"];
                
                
                //順番が重要
                prefAry = [[RLMArray alloc] initWithObjectClassName:@"Pref"];
                tmpCode = aobj.AreaCode;
                
                j = 1;
                
//                pobj.PrefCode = areaDict[@"PrefCode"];
//                pobj.PrefName = areaDict[@"PrefName"];
//                pobj.area = aobj;
//                pobj.id = j;
//                //pobj.owner = aobj;
//                [realm addObject:pobj];
//                [prefAry addObject:pobj];

                
            }else if(tmpCode != areaDict[@"AreaCode"] && i == 1){
                
                aobj = [[Area alloc] init];
                aobj.id = i;
                aobj.AreaCode = areaDict[@"AreaCode"];
                aobj.AreaName = areaDict[@"AreaName"];
                i++;
                
                //順番が重要
                prefAry = [[RLMArray alloc] initWithObjectClassName:@"Pref"];
                tmpCode = aobj.AreaCode;
                
                j = 1;
                
//                pobj.PrefCode = areaDict[@"PrefCode"];
//                pobj.PrefName = areaDict[@"PrefName"];
//                pobj.area = aobj;
//                pobj.id = j;
//                //pobj.owner = aobj;
//                [realm addObject:pobj];
//                [prefAry addObject:pobj];
                
                
                
//            }else{
                
                
                
            }
            pobj.PrefCode = areaDict[@"PrefCode"];
            pobj.PrefName = areaDict[@"PrefName"];
            pobj.area = aobj;
            pobj.id = j;
            [realm addObject:pobj];
            [prefAry addObject:pobj];
            j++;
            
            
            
            
        }
        
        [realm commitWriteTransaction];
        
        // Print all persons from realm
        for (Area *area in [Area allObjects]) {
            NSLog(@"Area persisted to realm: %@", area);
        }
        
        NSError *error2 = nil;
        
        BOOL result = [realm writeCopyToPath:@"/Users/hiratsukashu/Documents/shift_for_shuhu.realm" error:&error2];
        NSLog(@"%@", error2);
        NSLog(@"%d", result);
        
    }
    return 0;
}
