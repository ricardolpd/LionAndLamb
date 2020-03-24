//
//  CloudView.m
//  LionAndLamb
//
//  Created by Ricardo on 23/03/2020.
//  Copyright © 2020 Peter Christian Jensen. All rights reserved.
//

#import "CloudView.h"
#import "CloudLayoutOperation.h"

@interface CloudView() <CloudLayoutOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *cloudLayoutOperationQueue;

@end

@implementation CloudView

@synthesize fontName = _fontName;
@synthesize cloudColors = _cloudColors;
@synthesize cloudWords = _cloudWords;
@synthesize cloudTitle = _cloudTitle;
@synthesize cloudLayoutOperationQueue = _cloudLayoutOperationQueue;
#ifdef DEBUG
@synthesize debug = _debug;
#endif

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame: frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder: coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
  [super encodeWithCoder:coder];
}


- (void) dealloc {
  [self.cloudLayoutOperationQueue cancelAllOperations];
}

-(void) setup {
  // Custom initialization
  self.cloudLayoutOperationQueue = [[NSOperationQueue alloc] init];
  self.cloudLayoutOperationQueue.name = @"Cloud layout operation queue";
  self.cloudLayoutOperationQueue.maxConcurrentOperationCount = 1;
}

-(void) rearrangeWords {
  [self layoutCloudWords];
}

-(void) layoutCloudWords {
  // Cancel any in-progress layout
  [self.cloudLayoutOperationQueue cancelAllOperations];
  [self.cloudLayoutOperationQueue waitUntilAllOperationsAreFinished];
  
  [self removeCloudWords];
  NSString *title = self.cloudTitle != nil ? self.cloudTitle : @"Add a tittle";
  CloudLayoutOperation *newCloudLayoutOperation = [[CloudLayoutOperation alloc] initWithCloudWordsObject: self.cloudWords
                                                                                                   title: title
                                                                                                fontName:self.fontName
                                                                                    forContainerWithSize:CGSizeMake(300, 300)
                                                                                                   scale:[[UIScreen mainScreen] scale]
                                                                                                delegate:self];
  [self.cloudLayoutOperationQueue addOperation:newCloudLayoutOperation];
}

-(void) removeCloudWords {
    NSMutableArray *removableObjects = [[NSMutableArray alloc] init];
    
    // Remove cloud words (UILabels)
    
    for (UIView *subview in self.subviews)
    {
      if ([subview isKindOfClass:[UILabel class]])
      {
        [removableObjects addObject:subview];
      }
    }
    
    [removableObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
  #ifdef DEBUG
    // Remove bounding boxes
    
    [removableObjects removeAllObjects];
    
    for (CALayer *sublayer in self.layer.sublayers)
    {
      if ([sublayer isKindOfClass:[CALayer class]] && ((CALayer *)sublayer).borderWidth && ![sublayer delegate])
      {
        [removableObjects addObject:sublayer];
      }
    }
    
    [removableObjects makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  #endif
}

- (void)insertWord:(NSString *)word
         pointSize:(CGFloat)pointSize
             color:(NSUInteger)color
            center:(CGPoint)center
          vertical:(BOOL)isVertical {
  UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  
  wordLabel.text = word;
  wordLabel.textAlignment = NSTextAlignmentCenter;
  wordLabel.textColor = self.cloudColors[color < self.cloudColors.count ? color : 0];
  wordLabel.font = [UIFont fontWithName:self.fontName size:pointSize];
  
  [wordLabel sizeToFit];
  
  // Round up size to even multiples to "align" frame without ofsetting center
  CGRect wordLabelRect = wordLabel.frame;
  wordLabelRect.size.width = ((NSInteger)((CGRectGetWidth(wordLabelRect) + 3) / 2)) * 2;
  wordLabelRect.size.height = ((NSInteger)((CGRectGetHeight(wordLabelRect) + 3) / 2)) * 2;
  wordLabel.frame = wordLabelRect;
  
  wordLabel.center = center;
  
  if (isVertical)
  {
    wordLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
  }
  
#ifdef DEBUG
  if ([self respondsToSelector:@selector(debug)] && (BOOL)[self performSelector:@selector(debug)] == YES) {
    wordLabel.layer.borderColor = [UIColor redColor].CGColor;
    wordLabel.layer.borderWidth = 1;
  }
#endif
  [self addSubview:wordLabel];
}

#ifdef DEBUG
- (void)insertBoundingRect:(CGRect)rect
{
  CALayer *boundingRect = [CALayer layer];
  boundingRect.frame = rect;
  boundingRect.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5].CGColor;
  boundingRect.borderWidth = 1;
  [self.layer addSublayer:boundingRect];
}
#endif

- (void)insertTitle:(NSString *)cloudTitle {
  NSLog(@"title: %@", cloudTitle);
}

@end
