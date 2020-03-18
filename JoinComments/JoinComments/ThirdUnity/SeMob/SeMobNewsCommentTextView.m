//
//  SeMobNewsCommentTextView.m
//  SeMob
//
//  Created by qingtaogao on 2017/5/19.
//
//

#import "SeMobNewsCommentTextView.h"

@implementation SeMobNewsCommentTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setPlaceholder:@""];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification

{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
        
    }
    
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,8,self.bounds.size.width - 4,0)];
            
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.font = self.font;
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            
            placeHolderLabel.textColor = self.placeholderColor;
            
            placeHolderLabel.alpha = 0;
            
            placeHolderLabel.tag = 999;
            
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
        
    }
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
    
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}
- (void)setPlaceholderColor:(UIColor*) color {
    if (!color) {
        return ;
    }
    placeholderColor = color;
    [self setNeedsDisplay];
    
}
- (void)setPlaceholder:(NSString*)text{
    if (!text) {
        return;
    }
    placeholder = text;
    [self setNeedsDisplay];
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    placeHolderLabel = nil;
    
    placeholderColor = nil;
    
    placeholder = nil;
    
}
@end
