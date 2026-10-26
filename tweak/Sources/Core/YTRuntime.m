#import "YTRuntime.h"
#import <objc/runtime.h>

BOOL YTSwizzleInstanceMethod(Class cls, SEL origSel, SEL newSel) {
    if (!cls || !origSel || !newSel) return NO;
    Method origMethod = class_getInstanceMethod(cls, origSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    if (!origMethod || !newMethod) return NO;
    
    BOOL didAdd = class_addMethod(cls,
                                  origSel,
                                  method_getImplementation(newMethod),
                                  method_getTypeEncoding(newMethod));
    if (didAdd) {
        class_replaceMethod(cls,
                            newSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
    return YES;
}

NSArray<Class> *YTFindClassesMatching(NSString *keyword) {
    if (!keyword.length) return @[];
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses <= 0) return @[];
    
    Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray<Class> *results = [NSMutableArray array];
    for (int i = 0; i < numClasses; i++) {
        Class cls = classes[i];
        const char *name = class_getName(cls);
        if (name && strstr(name, keyword.UTF8String) != NULL) {
            [results addObject:cls];
        }
    }
    free(classes);
    return results;
}

UIViewController *YTFindViewControllerForView(UIView *view) {
    UIResponder *responder = view;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

UIView *YTFindSubviewMatching(UIView *root, NSString *classNamePrefix) {
    if (!root || !classNamePrefix.length) return nil;
    if ([NSStringFromClass([root class]) containsString:classNamePrefix]) {
        return root;
    }
    for (UIView *subview in root.subviews) {
        UIView *found = YTFindSubviewMatching(subview, classNamePrefix);
        if (found) return found;
    }
    return nil;
}
