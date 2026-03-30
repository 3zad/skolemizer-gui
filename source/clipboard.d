module clipboard;

import std.stdio;
import core.stdc.string;
import core.stdc.wchar_;
import std.string;
import std.conv;
import std.utf;

version(Windows) {
    extern(Windows) {
        bool OpenClipboard(void*);
        void* GetClipboardData(uint);
        void* SetClipboardData(uint, void*);
        bool EmptyClipboard();
        bool CloseClipboard();
        void* GlobalAlloc(uint, size_t);
        void* GlobalLock(void*);
        bool GlobalUnlock(void*);
        size_t GlobalSize(void*);
    }

    enum CF_UNICODETEXT = 13;

    string getFromClipboard() {
        string content = "";
        if (OpenClipboard(null)) {
            auto wstr = cast(wchar*)GetClipboardData(CF_UNICODETEXT);
            if(wstr) {
                size_t len = 0;
                while(wstr[len] != 0) len++;
                try {
                    content = to!string(wstr[0..len]);
                } catch(Exception e) {
                    writeln("Error converting clipboard data: ", e.msg);
                }
            }
            CloseClipboard();
        }
        return content;
    }

    void pushToClipboard(string data) {
        if (OpenClipboard(null)) {
            EmptyClipboard();

            // Convert UTF-8 string to UTF-16 for Windows otherewise garbage is pushed to clipboard
            wstring wdata;
            try {
                wdata = toUTF16(data);
            } catch(Exception e) {
                writeln("Error encoding to UTF-16: ", e.msg);
                CloseClipboard();
                return;
            }

            size_t bytes = (wdata.length + 1) * wchar.sizeof;
            void* handle = GlobalAlloc(2, bytes);
            void* ptr = GlobalLock(handle);
            
            if(ptr) {
                memcpy(ptr, wdata.ptr, wdata.length * wchar.sizeof);
                (cast(wchar*)ptr)[wdata.length] = 0;  // Null terminate
                GlobalUnlock(handle);
                SetClipboardData(CF_UNICODETEXT, handle);
            }
            
            CloseClipboard();
        }
    }
} else {
    string getFromClipboard() { return ""; }
    void pushToClipboard(string data) {}
}