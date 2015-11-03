//
//  CardDeck.h
//  CardDeckUI
//
//  Created by Saddam Akhtar on 27/10/15.
//  Copyright (c) 2015 Saddam Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDeck : UIView

@property (nonatomic) IBInspectable CGFloat X_Margin;
@property (nonatomic) IBInspectable CGFloat Y_Margin;

@property (nonatomic) IBInspectable CGFloat Angle_Rotation_Factor;
@property (nonatomic) IBInspectable CGFloat Y_Axis_Rotation_Factor;

-(void)layoutCardsWithDefaultMargins;
-(void)layoutCardsWithYAxisMargin:(CGFloat) yMargin AndXAxisMargin:(CGFloat)xMargin;
-(void)shuffleCard:(UIView *)card toFront:(BOOL) front;

@end
