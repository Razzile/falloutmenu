//
//  Delegate.h
//  CIV3_Menu
//
//  Created by callum taylor on 05/06/2015.
//  Copyright (c) 2015 Satori. All rights reserved.
//

#ifndef CIV3_Menu_Delegate_h
#define CIV3_Menu_Delegate_h


#include <functional>
#include <mutex>
#include <vector>

template <typename... Args>
class Delegate {
public:
    typedef std::function<void(Args...)> Listener;
    
    void AddListener(Listener const& listener) {
        std::lock_guard<std::mutex> guard(lock_);
        listeners_.push_back(listener);
    }
    
    void RemoveAllListeners() {
        std::lock_guard<std::mutex> guard(lock_);
        listeners_.clear();
    }
    
    void operator()(Args... args) {
        std::lock_guard<std::mutex> guard(lock_);
        for (auto& listener : listeners_) {
            listener(args...);
        }
    }
    
private:
    std::mutex lock_;
    std::vector<Listener> listeners_;
};


#endif
