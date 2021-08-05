# LuaParser
Construtor de Analisador Sintático em Lua

O analisador sintático em si está todo na pasta 'parser'. 
Dentro da pasta 'bhv' está um exemplo de como usar para definir sua própria linguagem, onde eu criei uma linguagem chamada de 'bhv' para testar o analisador.

O analisador é baseado em uma árvore de regras definida pelo usuário, e o resultado da análise é uma árvore sintática.
Tipos de regras:
* Sequence: Só aceita uma entrada se todas as suas sub-regras forem aceitas em ordem.
* Select: Retorna o resultado da primeira sub-regra que for aceita.
* Multiple: Aceita multiplas repetições de sua sub-regra. Uma quantidade mínima pode ser definida.
* Optional: Retorna o resultado da sua sub-regra se esta for aceita, caso contrário retorna uma árvore vazia.
* Pattern: Testa um padrão de string Lua e retorna o Token caso passe no teste.

Tipos especiais (podem apenas ser sub-regras de Sequence):
* Discard: Executa o teste da sub-regra, mas não inclui o resultado na árvore sintática.
* CheckPoint: Marca um ponto na árvore onde outras alternativas não devem ser testadas caso a atual falhe.

Outras funcionalidades:
* Token: Objeto que representa uma folha na árvore sintática.
* Tree: Objeto recursivo que representa a árvore sintática.
* StringStream: Objeto usado para controlar o uso da string de entrada.

