
import ply.lex as lex
import ply.yacc as yacc
import string

tokens = (
    "LT", "GT","LTCLOSE", "LTQUESTIONMARK", "QUESTIONMARKGT", "SINGLETAGGT","NAME","EQUAL","QUOTE","TEXT"
)

def build_lexer():
    states = (
        ("INTAG","exclusive"),
        ("INSTRING","exclusive"),
    )

    def t_COMMENT(t):
        r"(?s)<!--.+?-->"
        # return t
        pass

    # def t_XMLROOT(t):
    #     r"<\?xml[^>]+\?>"
    #     return t

    # def t_IGNORE(t):
    #     r"[n]+"
    #     return t

    def t_INITIAL_INTAG_LTQUESTIONMARK(t):
        r"<\?"
        t.lexer.push_state("INTAG")
        return t

    def t_INTAG_QUESTIONMARKGT(t):
        r"\?>"
        t.lexer.pop_state()
        return t

    def t_INITIAL_INTAG_LTCLOSE(t):
        r"</"
        t.lexer.push_state("INTAG")
        return t

    def t_INITIAL_INTAG_LT(t):
        r"<"
        t.lexer.push_state("INTAG")
        return t

    def t_INTAG_GT(t):
        r">"
        t.lexer.pop_state()
        return t

    def t_INTAG_SINGLETAGGT(t):
        r"/>"
        t.lexer.pop_state()
        return t

    def t_INTAG_NAME(t):
        r"[a-zA-Z_]+"
        return t

    def t_INTAG_SPACE(t):
        r"\s+"
        # return t
        pass

    def t_INTAG_EQUAL(t):
        r"="
        return t

    def t_INTAG_QUOTE(t):
        r"\""
        t.lexer.push_state("INSTRING")
        return t

    def t_INSTRING_QUOTE(t):
        r"\""
        t.lexer.pop_state()
        return t

    def t_INSTRING_TEXT(t):
        r"[^\"]+"
        return t

    def t_TEXT(t):
        r"[^<]+"
        return t

    def t_error(t):
        print "error",t

    def t_INSTRING_error(t):
        print "instring", t

    def t_INTAG_error(t):
        print "intag", t

    lex.lex()


def build_parser():
    def p_children(p):
        '''children : child children
                    | empty
        '''
        if len(p) == 3:
            if p[2]:
                p[0] = [p[1]] + p[2]
            else:
                p[0] = [p[1]]
        else:
            p[0] = []

    def p_child(p):
        '''child : element
                 | text
        '''
        p[0] = p[1]

    def p_element(p):
        '''element : opentag children closetag
                   | lonetag
                   | questionmarktag
        '''
        if len(p) == 4:
            p[0]=(p[1][0],p[1][1],p[2])
        else:
            p[0]=(p[1][0],p[1][1],[])

    def p_opentag(p):
        '''opentag : LT NAME attrs GT
        '''
        p[0] = (p[2],p[3])

    def p_closetag(p):
        '''closetag : LTCLOSE NAME GT
        '''
        p[0] = p[2]

    def p_questionmarktag(p):
        '''questionmarktag : LTQUESTIONMARK NAME attrs QUESTIONMARKGT
        '''
        p[0] = (p[2],p[3])

    def p_lonetag(p):
        '''lonetag : LT NAME attrs SINGLETAGGT
        '''
        p[0] = (p[2],p[3])

    def p_string(p):
        '''string : QUOTE text QUOTE
        '''
        p[0] = p[2]

    def p_text(p):
        '''text : TEXT
                | empty
        '''
        if len(p) == 2:
            p[0] = p[1]
        else:
            p[0] = ""

    def p_attr(p):
        '''attr : NAME EQUAL string
        '''
        p[0] = {p[1]:p[3]}

    def p_attrs(p):
        '''attrs : attr attrs
                 | empty
        '''
        if len(p) == 3:
            if p[2]:
                p[1].update(p[2])
                p[0] = p[1]
            else:
                p[0] = p[1]
        else:
            p[0] = {}

    def p_empty(p):
        '''empty :
        '''
        pass

    def p_error(p):
        print "Syntax error", p

    yacc.yacc(debug=False)

def parse(data):
    build_lexer()
    build_parser()
    return yacc.parse(data)

def main():
    with open("./ftl-resources/data/blueprints.xml") as f:
        s = ''.join(list(f))
        s = filter(lambda x: x in string.printable,s)

        result = parse(s)

        print result

        # lex.input(s)
        # for tok in iter(lex.token, None):
        #     print repr(tok.type), repr(tok.value)

        # lexer(s)


if __name__ == '__main__':
    main()  