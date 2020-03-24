//
//  CloudView.h
//  LionAndLamb
//
//  Created by Ricardo on 23/03/2020.
//  Copyright © 2020 Peter Christian Jensen. All rights reserved.
//

@import UIKit;

@interface CloudView : UIView

@property(nonatomic, strong) NSString *fontName;
@property(nonatomic, strong) NSArray *cloudWords;
@property(nonatomic, strong) NSString *cloudTitle;
// Delete
@property(nonatomic, strong) NSArray *cloudColors;

#ifdef DEBUG
@property (nonatomic, assign) BOOL debug;
#endif

-(void) rearrangeWords;
-(void) layoutCloudWords;
-(void) removeCloudWords;

@end
