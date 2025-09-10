%{
#include <bits/stdc++.h>

using namespace std;

struct Symbol {
    string name;       
    string kind;       
    string dtype;      // declared type (int/float/...),
    int line;
    string qualifier;  // e.g. "const", "static", or empty
};

vector<Symbol> table;
string current_type = "";   // holds last seen declaration type until semicolon
string pending_qual = "";   // accumulates "const"/"static" seen before declaration
int line_no = 1;

const vector<string> keywords = {
    "int","float","char","double","void",
    "if","else","for","while","return","const","static","long","short","signed","unsigned"
};

bool is_keyword(const string &s){
    return find(keywords.begin(), keywords.end(), s) != keywords.end();
}

void add_symbol(const string& name, const string& kind, const string& dtype, int line, const string& qual) {
    // keep first-seen entry only (simple symbol table)
    for (auto &sym : table) {
        if (sym.name == name && sym.kind == kind) return;
    }
    table.push_back({name, kind, dtype, line, qual});
}
%}


%%

"const"    { pending_qual = pending_qual.empty() ? "const" : (pending_qual + " const"); }
"static"   { pending_qual = pending_qual.empty() ? "static" : (pending_qual + " static"); }

"int"|"float"|"char"|"double"|"void"|"long"|"short"|"signed"|"unsigned" {
    current_type = string(yytext);
    cout << "Keyword: " << yytext << '\n';
}

[a-zA-Z_][a-zA-Z0-9_]* {
    string s = yytext;
    if (is_keyword(s)) {
        cout << "Keyword: " << s << '\n';
    } else {
        string dtype = current_type.empty() ? "unknown" : current_type;
        string qual = pending_qual;
        add_symbol(s, "identifier", dtype, line_no, qual);
    }
}

[0-9]*\.[0-9]+([eE][+-]?[0-9]+)? {
    add_symbol(string(yytext), "constant", "float", line_no, "");
}

[0-9]+([eE][+-]?[0-9]+)? {
    add_symbol(string(yytext), "constant", "int", line_no, "");
}

\"([^\"\n]|\\.)*\" {
    add_symbol(string(yytext), "constant", "string", line_no, "");
}

";" {
    current_type.clear();
    pending_qual.clear();
}

\n      { ++line_no; }
[ \t\r]+ ;
.        ;
%%


int yywrap(){ return 1; }

int main(int argc, char **argv) {
    yylex();
    cout << "\nSymbol Table:\n";
    cout << "Name\tKind\t\tType\tLine\tQualifier\n";
    for (const auto &s : table) {
        cout << s.name << "\t" << s.kind << "\t" << s.dtype << "\t" << s.line << "\t"
             << (s.qualifier.empty() ? "-" : s.qualifier) << "\n";
    }
    return 0;
}
