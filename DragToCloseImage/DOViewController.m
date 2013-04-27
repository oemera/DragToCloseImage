//
//  DOViewController.m
//  DragToCloseImage
//
//  Created by Ömer Avci on 21.04.13.
//  Copyright (c) 2013 Ömer Avci. All rights reserved.
//

#define kAnimationDuration 0.2f

#import <QuartzCore/QuartzCore.h>
#import "DOViewController.h"

@interface DOViewController() {
    UIImageView *_imageView;
    UIView *_backgroundView;
    UISwipeGestureRecognizer *_swipeUpGesture;
    UISwipeGestureRecognizer *_swipeDownGesture;
}

@end
@implementation DOViewController

- (IBAction)showImageOverlay:(id)sender {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _backgroundView.alpha = 0.0f;
        _backgroundView.userInteractionEnabled = YES;
    }
    
    if (_imageView == nil) {
        UIImage *image = [UIImage imageNamed:@"sample-image.jpg"];
        CGRect imageViewFrame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.size.height,
                                           _backgroundView.frame.size.width, _backgroundView.frame.size.height);
        _imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        _imageView.image = image;
        
        if (_swipeDownGesture == nil) {
            _swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownHappened:)];
            _swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
            [_imageView addGestureRecognizer:_swipeDownGesture];
        }
        if (_swipeUpGesture == nil) {
            _swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpHappened:)];
            _swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
            [_imageView addGestureRecognizer:_swipeUpGesture];
        }
    }
    
    [_backgroundView addSubview:_imageView];
    [self.view addSubview:_backgroundView];
    
    [UIView animateWithDuration:kAnimationDuration animations:^(void) {
        _backgroundView.alpha = 0;
        _backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration animations:^(void) {
            CGRect frame = _imageView.frame;
            frame.origin.y = 0;
            _imageView.frame = frame;
        }];
    }];
}

- (void)swipeUpHappened:(UISwipeGestureRecognizer *)sender {
    NSLog(@"user swiped with one finger up");
    [self moveViewFromSuperViewAnimatedWithView:_imageView backgroundView:_backgroundView andToValue:-600];
}

- (void)swipeDownHappened:(UISwipeGestureRecognizer *)sender {
    NSLog(@"user swiped with one finger down");
    [self moveViewFromSuperViewAnimatedWithView:_imageView backgroundView:_backgroundView andToValue:600];
}

#pragma mark - Animations

- (void)moveViewFromSuperViewAnimatedWithView:(UIView *)view
                               backgroundView:(UIView *)backgroundView
                                   andToValue:(CGFloat)toValue {
    [UIView animateWithDuration:kAnimationDuration animations:^(void) {
        CGRect frame = view.frame;
        frame.origin.y = toValue;
        view.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration animations:^(void) {
            backgroundView.alpha = 1;
            backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [backgroundView removeFromSuperview];
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
