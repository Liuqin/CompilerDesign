%{
#include <iostream>
#include <string>
class node;
class symbol_tabel;
class symbol_tabel_mananger;

#include <cstdio>
#include <string>
#include <cassert>

const int ILEGAL = -2;
const int UNDEFINED = -1;
const int RESERVED_WORD = 1;
//const int OPERATOR = 2;
const int IDENTIFIER = 3;
const int INT = 4;//here refers to "int", int variables refers to identifier

const int LEFT_BRACKET = 6;
const int RIGHT_BRACKET = 7;
const int LEFT_BRACE = 8;
const int RIGHT_BRACE = 9;
const int IF_ = 10;
const int FN = 11;
const int MUT = 12;
const int LET_ = 13;
const int WHILE_ = 14;
const int COLON = 15;
const int SEMI_COLON = 16;
const int STRING_ = 17;

std::string undefined_name = "UNDEFINED";
std::string reserved_word_name = "RESERVED_WORD";
//std::string operator_name = "OPERATOR";
std::string identifier_name = "IDENTIFIER";
std::string int_name = "INT";
std::string float_name = "FLOAT";
std::string left_bracket_name = "LEFT_BRACKET";
std::string right_bracket_name = "RIGHT_BRACKET";
std::string left_brace_name = "LEFT_BRACE";
std::string right_brace_name = "RIGHT_BRACE";
std::string if_name = "if";
std::string fn_name = "fn";
std::string mut_name = "mut";
std::string let_name = "let";
std::string while_name = "WHILE";
std::string colon_name = "COLON";
std::string semi_colon_name = "SEMI_COLON";
std::string string_name = "STRING";

void handle_token(int type, std::string name){
	if(type == IDENTIFIER){
		std::cout << identifier_name << " " << name << std::endl;
	}
	if(type == LEFT_BRACKET){
		std::cout << left_bracket_name << " " << name << std::endl;
	}
	if(type == RIGHT_BRACKET){
		std::cout << right_bracket_name << " " << name << std::endl;
	}
	if(type == LEFT_BRACE){
		std::cout << left_brace_name << " " << name << std::endl;
	}
	if(type == RIGHT_BRACE){
		std::cout << right_brace_name << " " << name << std::endl;
	}
	if(type == IF_){
		std::cout << if_name << " " << name << std::endl;
	}
	if(type == FN){
		std::cout << fn_name << " " << name << std::endl;
	}
	if(type == MUT){
		std::cout << mut_name << " " << name << std::endl;
	}
	if(type == LET_){
		std::cout << let_name << " " << name << std::endl;
	}
	if(type == WHILE_){
		std::cout << while_name << " " << name << std::endl;
	}
	if(type == COLON){
		std::cout << colon_name << " " << name << std::endl;
	}
	if(type == SEMI_COLON){
		std::cout << semi_colon_name << " " << name << std::endl;
	}
	if(type == STRING_){
		std::cout << string_name << " " << name << std::endl;
	}
}

std::string to_string( int x ) {
  int length = snprintf( NULL, 0, "%d", x );
  assert( length >= 0 );
  char* buf = new char[length + 1];
  snprintf( buf, length + 1, "%d", x );
  std::string str( buf );
  delete[] buf;
  return str;
}

class node{
	public:
	std::string name;
	int type = -1;
	node(){

	}
	std::string info(){
		return "name: " + name + " type: " + to_string(type);
	}
};
class symbol_tabel{
	public:
	node * symbols;
	int index = 0;
	symbol_tabel(){
		symbols  = new node[1000];
	}
	int lookup(std::string name){
		/*return -1 if not found
		  return index if found
		*/
		for(int i = 0; i< index; i+=1){
			if (symbols[i].name == name){
				return i;
			}
		}
		return -1;
	}
	void insert(node targetnode){
		if (lookup(targetnode.name) != -1){
			return;
		}
		symbols[index] = targetnode;
		index +=1;
	}
	void dump(){
		std::cout << "------dump current symbol_tabel--------------------"<<std::endl;
		for(int i = 0; i < index; i++){
			//std::cout << "name: " << symbols[i].name << " type: " << symbols[i].type << std::endl;
			std::cout << symbols[i].info()<< std::endl;
		}
		std::cout << "------current symbol_tabel dump finished-----------"<< std::endl;
	}
};
class symbol_tabel_mananger{
	public:
	symbol_tabel * stm;
	int index = 0;
	

	node lookup(std::string name){
		for(int i = index-1; i>=0; i--){
			int symbol_idx = stm[i].lookup(name);
			if  (stm[i].lookup(name)!= -1){
				return stm[i].symbols[symbol_idx];
			}
		}
		node a = node();
		a.type = ILEGAL;
		return a;
	}
	void delete_upmost_sybol_tabel(){
		if(index >0){
			stm[index].dump();
			index -= 1;
		}

	}
	
	void register_new_symbol_tabel(){
		stm[index] = symbol_tabel();
		index +=1;
	}

	void insert(node current){
		stm[index].insert(current);
	}

	void dump(){
		for(int i = index-1; i>=0; i--){
			stm[index].dump();
		}
	}

	symbol_tabel_mananger(){
		stm = new symbol_tabel[100];
		register_new_symbol_tabel();
	}
};
symbol_tabel_mananger stm = symbol_tabel_mananger();
int total_line_count = 0; //total line of the source code
%}

%s COMMENT
chars [A-Za-z]
digits [0-9]

%%
[ |\t]+	{/*empty*/}

"//".* {/*comments*/}

"/*" {BEGIN COMMENT; std::cout << "enter comment mode at line " << total_line_count << std::endl;}
<COMMENT>"*/" {BEGIN 0; std::cout << "quit comment mode at line " << total_line_count << std::endl;}
<COMMENT>[^(*/)\n]* {/*ignore comment*/}
<COMMENT>\n {total_line_count +=1;}


fn {handle_token(FN,"fn");}
let {handle_token(LET_,"let");}
mut {handle_token(MUT, "mut");}
"(" {handle_token(LEFT_BRACKET,"(");}
")" {handle_token(RIGHT_BRACKET,")");}
"{" {handle_token(LEFT_BRACE,"{");
	stm.register_new_symbol_tabel();}
"}" {handle_token(RIGHT_BRACE,"}");
	stm.delete_upmost_sybol_tabel();}
if {handle_token(IF_,"if");}
while {handle_token(WHILE_,"while");}

{chars}+[{chars}_{digits}]* {handle_token(IDENTIFIER,yytext);
							node current = node();
							current.name = yytext;
							stm.insert(current);}
":"	{handle_token(COLON,":");}
";"	{handle_token(SEMI_COLON,";");}
\".*\"	{handle_token(STRING_, yytext);}

\n {total_line_count += 1;}


%%

int main(){
	std::cout << "initialzing scanner"<< std::endl;
	yylex();
	std::cout << total_line_count << std::endl;
	stm.dump();
}