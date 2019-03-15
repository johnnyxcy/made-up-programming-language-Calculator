class Token
    ##
    # supports the following kind:
    # LPAREN: left parentheses
    # RPAREN: right parentheses
    # EQUAL: ==
    # ASSIGN: id=exp
    # NEQ: !=
    # NOT: !
    # LEQ: <=
    # LESS: <
    # GEQ: >=
    # GREATER: >
    # INTEGER: int
    # ID: identifier
    # IF: if
    # WHILE: while
    # AND: and
    # OR: or
    # PRINT: print
    # RETURN: return
    # SQRT: sqrt
    # POWER: power
    # CLEAR: clear all ids
    # LIST: list all ids
    # STRING: a string
    # ADD: +
    # ADDSELF: +=
    # MINUS: -
    # MINUSSELF: -=
    # DIVIDE: /
    # DIVIDESELF: /=
    # TIMES: *
    # TIMESSELF: *=
    # RAISETO: ^
    # EOF: end of file
    def initialize(keyword, id='', int=-1, str='')
        @kind = keyword
        if keyword == 'INTEGER'
            @int = int
        elsif keyword == 'ID'
            @id = id
        elsif keyword == 'STRING'
            @str = str
        end
    end

    def kind
        @kind
    end

    def value
        if @kind == 'INTEGER'
            return @int
        elsif @kind == 'ID'
            return @id
        end
    end
    def to_s
        if @kind == 'LPAREN'
            return 'left parentheses'
        elsif @kind == 'RPAREN'
            return 'right parentheses'
        elsif @kind == 'SEMICOLON'
            return 'semicolons'
        elsif @kind=='EQUAL'
            return 'equal to'
        elsif @kind=='ASSIGN'
            return 'assign to'
        elsif @kind=='NEQ'
            return 'not equal to'
        elsif @kind=='NOT'
            return 'is not'
        elsif @kind=='LEQ'
            return 'less than or equal to'
        elsif @kind=='LESS'
            return 'less than'
        elsif @kind=='GEQ'
            return 'greater than or equal to'
        elsif @kind=='GREATER'
            return 'greater than'
        elsif @kind=='INTEGER'
            return 'integer value %d' % [@int]
        elsif @kind=='ID'
            return 'identifier with name %s' % [@id]
        elsif @kind == 'STRING'
            return 'A string %s' % [@str]
        elsif @kind=='IF'
            return 'if'
        elsif @kind=='ELSE'
            return 'else'
        elsif @kind=='WHILE'
            return 'while'
        elsif @kind=='FOR'
            return 'for'
        elsif @kind=='END'
            return 'end'
        elsif @kind=='AND'
            return 'and'
        elsif @kind=='OR'
            return 'or'
        elsif @kind=='PRINT'
            return 'print'
        elsif @kind=='RETURN'
            return 'return'
        elsif @kind=='SQRT'
            return 'sqrt'
        elsif @kind=='POWER'
            return 'power'
        elsif @kind=='CLEAR'
            return 'clear all ids'
        elsif @kind=='LIST'
            return 'list all ids'
        elsif @kind=='ADD'
            return 'add to'
        elsif @kind=='ADDSELF'
            return 'increase by'
        elsif @kind=='MINUS'
            return 'substract to'
        elsif @kind=='MINUSSELF'
            return 'decrease by'
        elsif @kind == 'DIVIDE'
            return 'divided by'
        elsif @kind == 'DIVIDESELF'
            return 'divided by'
        elsif @kind=='TIMES'
            return 'times by'
        elsif @kind=='TIMESSELF'
            return 'times by'
        elsif @kind=='RAISETO'
            return 'raise to the power of'
        elsif @kind=='EOF'
            return 'end of file'
        end
    end
end

class Scanner
    def initialize(input)
        @input = input.split('')
    end

    def getToken
        ints = ('0'..'9').to_a
        alphabets = ('a'..'z').to_a + ('A'..'Z').to_a
        keywords = {
            'if'=> 'IF',
            'else'=> 'ELSE',
            'while'=> 'WHILE',
            'for'=> 'FOOR',
            'end'=> 'END',
            'and'=> 'AND',
            'or'=> 'OR',
            'print'=> 'PRINT',
            'return'=> 'RETURN',
            'sqrt'=> 'SQRT',
            'power'=> 'POWER',
            'clear'=> 'CLEAR',
            'list'=> 'LIST'
        }
        output = Array.new
        while !@input.empty?
            token = @input.shift(1)[0]

            if token == '\''
                str = '\''
                next_token = @input.shift(1)[0]
                while next_token != '\''
                    str = str + next_token
                    next_token = @input.shift(1)[0]
                end
                str = str + '\''
                output.append(Token.new('STRING', '', -1, str))
            elsif token == '"'
                str = '\''
                next_token = @input.shift(1)[0]
                while next_token != '"'
                    str = str + next_token
                    next_token = @input.shift(1)[0]
                end
                str = str + '\''
                output.append(Token.new('STRING', '', -1, str))
            elsif token.match(/\s+/)
                # skip
            elsif token == '('
                output.append(Token.new('LPAREN'))
            elsif token == ')'
                output.append(Token.new('RPAREN'))
            elsif token == ';'
                output.append(Token.new('SEMICOLON'))
            elsif token == '='
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('EQUAL'))
                    @input.shift(1)
                else
                    output.append(Token.new('ASSIGN'))
                end
            elsif token == '+'
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('ADDSELF'))
                    @input.shift(1)
                else
                    output.append(Token.new('ADD'))
                end
            elsif token == '-'
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('MINUSSELF'))
                    @input.shift(1)
                else
                    output.append(Token.new('MINUS'))
                end
            elsif token == '/'
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('DIVIDESELF'))
                    @input.shift(1)
                else
                    output.append(Token.new('DIVIDE'))
                end
            elsif token == '*'
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('TIMESSELF'))
                    @input.shift(1)
                elsif next_token == '*'
                    output.append(Token.new('RAISETO'))
                    @input.shift(1)
                else
                    output.append(Token.new('TIMES'))
                end
            elsif token == '!'or token == '!='
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('NEQ'))
                    @input.shift(1)
                else
                    output.append(Token.new('NOT'))
                end
            elsif token == '<'
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('LEQ'))
                    @input.shift(1)
                else
                    output.append(Token.new('LESS'))
                end
            elsif token == '>'
                next_token = @input.first(1)[0]
                if next_token == '='
                    output.append(Token.new('GEQ'))
                    @input.shift(1)
                else
                    output.append(Token.new('GREATER'))
                end
            elsif ints.include?(token)
                num = token
                next_token = @input.first(1)[0]
                while ints.include?(next_token)
                    num = num + next_token
                    @input.shift(1)
                    next_token = @input.first(1)[0]
                end
                output.append(Token.new('INTEGER', '', int=num.to_i))
            elsif alphabets.include?(token)
                str = token
                next_token = @input.first(1)[0]
                while alphabets.include?(next_token) or ints.include?(next_token) or next_token == '_'
                    str = str + next_token
                    @input.shift(1)
                    next_token = @input.first(1)[0]
                end
                if keywords.include?(str)
                    output.append(Token.new(keywords[str]))
                else
                    output.append(Token.new('ID', str))
                end
            end
        end
        output.append(Token.new('EOF'))
        return output
    end

    def to_s()
        @input.to_s
    end
end