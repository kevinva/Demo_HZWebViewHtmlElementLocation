//
//  ViewController.m
//  Demo_HZWebViewHtmlElementLocation
//
//  Created by Zander Harrison on 15/1/16.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import "ViewController.h"

typedef enum: NSUInteger {
    GESTURE_START,
    GESTURE_MOVING,
    GESTURE_END
} HZWebGestureState;

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (assign, nonatomic) HZWebGestureState gestureState;
@property (strong, nonatomic) NSString *webImageLink;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [_myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"touchWeb.js" ofType:nil];
    NSString *jsCode = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    [_myWebView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestLink = request.URL.absoluteString;
    
#ifdef DEBUG
    NSLog(@"%s, requestLink: %@", __FUNCTION__, requestLink);
#endif
    
    if ([requestLink hasPrefix:@"myweb"]) {
        NSArray *components = [requestLink componentsSeparatedByString:@":"];
        if (components.count > 1) {
            NSString *gestureStr = (NSString *)components[1];
            if ([gestureStr isEqualToString:@"touch"]) {
                NSString *state = (NSString *)components[2];
                
                if ([state isEqualToString:@"start"]) {
                    self.gestureState = GESTURE_START;
                    float touchX = [components[3] floatValue];
                    float touchY = [components[4] floatValue];
                    
                    NSString *jsCode = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", touchX, touchY];
                    NSString *tagName = [_myWebView stringByEvaluatingJavaScriptFromString:jsCode];
                    
#ifdef DEBUG
                    NSLog(@"%s, touch(%f, %f), tagName: %@", __FUNCTION__, touchX, touchY, tagName);
#endif
                    
                    if ([tagName isEqualToString:@"IMG"] || [tagName isEqualToString:@"img"]) {
                        NSString *imageJsCode = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchX, touchY];
                        self.webImageLink = [_myWebView stringByEvaluatingJavaScriptFromString:imageJsCode];
                    }
                    else {
                        self.webImageLink = nil;
                    }
                }
                else if ([state isEqualToString:@"move"]) {
                    self.gestureState = GESTURE_MOVING;
                }
                else if ([state isEqualToString:@"end"]) {
                    if (_gestureState != GESTURE_MOVING && _webImageLink) {
                        
#ifdef DEBUG
                        NSLog(@"%s, webImageLink: %@", __FUNCTION__, _webImageLink);
#endif
                        
                    }
                    
                    self.gestureState = GESTURE_END;
                }
            }
        }
        
        return NO;
    }
    
    return YES;
}

@end
