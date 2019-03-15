# CSE413 HW8
# Chongyi Xu, 1531273
# This program will parse the input and evaluate its behavior.
require 'readline'
require_relative 'scan'

# Evaluation
# program ::= statement | program statement
# statement ::= exp | id = exp | clear id | list | quit | exit
# exp ::= term  |  exp + term  |   exp - term
# term ::= power  |  term * power | term / power
# power ::= factor  |  factor ** power 
# factor ::= id  |  number  |  ( exp ) | sqrt ( exp )
def evaluate(tokens)
    # Evaluate the tokens recursively
    token = tokens.shift(1)[0]
    type = token.kind
    if type == 'LPAREN' # if the current token is '('
        tokens_to_evaluate = Array.new
        next_token = tokens.shift(1)[0]
        k = 1
        # get all tokens util ')'
        while !tokens.empty? and (next_token.kind != 'RPAREN' or k != 1)
            tokens_to_evaluate.push(next_token)
            if next_token.kind == 'LPAREN'
                k += 1
            elsif next_token.kind == 'RPAREN'
                k -= 1
            end
            next_token = tokens.shift(1)[0]
        end
        tokens_to_evaluate.push(Token.new('EOF'))
        if tokens.empty?
            puts('Error: Parenthese is not closed')
        else
            # Add a dummy token to the beginning of the token list
            tokens.insert(0, Token.new('INTEGER', id='', int=evaluate(tokens_to_evaluate)))
            return evaluate(tokens)
        end
    elsif type == 'ID' # if the current token is an identifier
        id = token.value # get its ID name
        next_token = tokens.shift(1)[0]

        if next_token.kind == 'EOF' # if it is the last token in the input
            if $map.include?(id)
                return $map[id]
            else
                puts('Error: id %s has not assigned yet' % [id])
            end
        elsif next_token.kind == 'ASSIGN' # if it is used to assign
            $map[id] = evaluate(tokens)
        elsif next_token.kind == 'MINUS' # if it is used to substract
            if $map.include?(id)
                return $map[id] - evaluate(tokens)
            else
                puts('Error: id %s has not assigned yet' % [id])
            end
        elsif next_token.kind == 'ADD' # if it is used to add
            if $map.include?(id)
                return $map[id] + evaluate(tokens)
            else
                puts('Error: id %s has not assigned yet' % [id])
            end
        elsif next_token.kind == 'TIMES' # if it is used to multiply
            if $map.include?(id)
                return $map[id] * evaluate(tokens)
            else
                puts('Error: id %s has not assigned yet' % [id])
            end
        elsif next_token.kind == 'DIVIDE' # if it is used to divide
            if $map.include?(id)
                return $map[id] / evaluate(tokens)
            else
                puts('Error: id %s has not assigned yet' % [id])
            end
        elsif next_token.kind == 'RAISETO' # if it is used to power
            if $map.include?(id)
                return $map[id] ** evaluate(tokens)
            else
                puts('Error: id %s has not assigned yet' % [id])
            end
        end
    elsif type == 'INTEGER' # if current token is an integer
        num = token.value
        next_token = tokens.shift(1)[0]
        if next_token.kind == 'EOF' # if it is the last token in the input
            return num
        elsif next_token.kind == 'MINUS' # if it is used to substract
            return num - evaluate(tokens)
        elsif next_token.kind == 'ADD' # if it is used to add
            return num + evaluate(tokens)
        elsif next_token.kind == 'TIMES' # if it is used to multiply
            return num * evaluate(tokens)
        elsif next_token.kind == 'DIVIDE' # if it is used to divide
            return num / evaluate(tokens)
        elsif next_token.kind == 'RAISETO' # if it is used to power
            return num ** evaluate(tokens)
        end
    elsif type == 'SQRT' # if the current token is a SQRT operation
        return Math.sqrt(evaluate(tokens))
    elsif type == 'MINUS' # if the current token is a negative sign
        return -1 * evaluate(tokens)
    elsif type == 'LIST' # if the current token wants to list all ids
        puts($map.to_s)
    elsif type == 'CLEAR' # if the current token wants to clear ids
        next_token = tokens.shift(1)[0]
        if next_token.kind == 'EOF' # clear all ids
            $map = Hash.new
            puts('Success: all local bindings have been cleared')
        else # clear given id
            id_to_clear = next_token.value
            if $map.include?(id_to_clear)
                $map.delete(id_to_clear)
                puts('Success: %s has been cleared' % [id_to_clear])
            else
                puts('Error: given %s is not assigned yet' % [id_to_clear])
            end
        end
    end
    return nil
end    

# parse input
$map = Hash.new
while line = Readline.readline('> ', true)
    if line == 'quit' or line == 'exit'
        break
    else
        input = Scanner.new(line)
        tokens = input.getToken
        result = evaluate(tokens)
        if !result.nil?
            puts(result)
        end
    end
end
