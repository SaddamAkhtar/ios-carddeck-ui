//
//  CardDeck.m
//  CardDeckUI
//
//  Created by Saddam Akhtar on 27/10/15.
//  Copyright (c) 2015 Saddam Akhtar. All rights reserved.
//

#import "CardDeck.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation CardDeck {
    CGFloat expandCollapseFactor;
    CGPoint panningCardOriginalCenter;
}

#pragma mark - UIView Override methods

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initWithDefaultValues];
    }
    return  self;
}

- (void)awakeFromNib {
    [self layoutCardsWithDefaultMargins];
}

#pragma mark -

-(void)initWithDefaultValues {
    self.Angle_Rotation_Factor = 5.0f;
    self.Y_Axis_Rotation_Factor = 5.0f;
    expandCollapseFactor = 0.5f;
}

// Updates the subviews in a deck fashion
// yMargin, xMargin - the top and left margin between each cards
-(void)layoutCardsWithYAxisMargin:(CGFloat)yMargin AndXAxisMargin:(CGFloat)xMargin {
    CGFloat cardYAxisMargin = yMargin;
    CGFloat cardXAxisMargin = xMargin;
    int cardIndex = (int)[self subviews].count - 1;
    
    // Center point of the container
    CGPoint containerCenter = [self convertPoint:self.center fromView:self.superview];
    
    for (UIView *card in [self subviews]) {
        CGPoint cardCenter = card.center;
        cardCenter.x = containerCenter.x - (cardIndex * cardXAxisMargin);
        cardCenter.y = containerCenter.y - (cardIndex * cardYAxisMargin);
        card.center = cardCenter;
        
        UIPanGestureRecognizer *cardPanGesture = [[UIPanGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(layoutCardPan:)];
        [card addGestureRecognizer:cardPanGesture];
        
        cardIndex--;
    }
}

// Layout the subviews in a deck fashion
// When adding subviews at runtime
// Should be called explicitly after subviews are added to layout the deck
-(void)layoutCardsWithDefaultMargins {
    [self layoutCardsWithYAxisMargin:self.Y_Margin AndXAxisMargin:self.X_Margin];
}

#pragma mark - Card Shuffle Methods

-(void)shuffleCard:(UIView *)card toFront:(BOOL)front {
    if ([card superview] == self) {
        [UIView animateWithDuration:0.2 animations:^{
            card.transform = CGAffineTransformIdentity;
            if (front) {
                [self bringSubviewToFront:card];
            } else {
                [self sendSubviewToBack:card];
            }
            
            [self layoutCardsWithDefaultMargins];
        }];
    } else {
        // card is not a subview of self
    }
    
}

// Increase vertical margin between each card
-(void)expandCards:(NSArray *)cards {
    CGFloat expandFactor = expandCollapseFactor;
    for (UIView *card in cards) {
        CGPoint cardCenter = card.center;
        cardCenter.y += expandFactor++;
        card.center = cardCenter;
    }
}

// Decreases vertical margin between each card
-(void)collapseCards:(NSArray *)cards {
    CGFloat collapseFactor = expandCollapseFactor;
    for (UIView *card in cards) {
        CGPoint cardCenter = card.center;
        cardCenter.y -= collapseFactor++;
        card.center = cardCenter;
    }
}

#pragma mark - Card Pan Gesture Methods

// pan gesture handler
-(void)layoutCardPan:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint velocity = [panRecognizer velocityInView:self];
    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
    
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            panningCardOriginalCenter = panRecognizer.view.center;
            break;
        case UIGestureRecognizerStateChanged:
            if (isVerticalGesture) {
                if (velocity.y > 0) {   // user dragged towards the bottom
                    [self expandCards:self.subviews];
                }
                else {   // user dragged towards the top
                    [self collapseCards:self.subviews];
                }
            } else {
                CGPoint translation = [panRecognizer translationInView:self];
                panRecognizer.view.center = CGPointMake(panningCardOriginalCenter.x + translation.x,
                                                        panningCardOriginalCenter.y + translation.y/_Y_Axis_Rotation_Factor);
                panRecognizer.view.transform =
                CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(translation.x
                                                                 / _Angle_Rotation_Factor));
            }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (velocity.x > 0) {   // user dragged towards the right
            }
            else {   // user dragged towards the left
            }
            
            // Enabling shuffle if difference in x axis is more than xDiffForShuffle
            CGFloat xDiffForShuffle = 50.0f;
            BOOL shuffleCard = NO;
            CGFloat xAxisPan = panRecognizer.view.center.x - panningCardOriginalCenter.x;
            if (xAxisPan > xDiffForShuffle || xAxisPan < -xDiffForShuffle)  {
                shuffleCard = YES;
            }
            
            if (shuffleCard) {
                if (self.subviews.lastObject == panRecognizer.view)
                    [self shuffleCard:panRecognizer.view toFront:NO];
                else
                    [self shuffleCard:panRecognizer.view toFront:YES];
            } else { // Bring back to previous position
                panRecognizer.view.transform = CGAffineTransformIdentity;
                [self layoutCardsWithDefaultMargins];
            }
            break;
        }
        default:
            break;
    }
}

@end
