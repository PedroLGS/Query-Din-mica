CREATE DATABASE exerc
GO
USE exerc  -- Exercicio 
GO
CREATE TABLE produto(
codigo        INT                NOT NULL,
nome          VARCHAR(100)       NOT NULL,
valor         DECIMAL(7,2)       NOT NULL
PRIMARY KEY(codigo)
)  
GO
CREATE TABLE entrada(
codigo_transacao      INT                NOT NULL,
codigo_produto        INT                NOT NULL,
quantidade            INT                NOT NULL,
valor_total           DECIMAL(7,2)       NOT NULL
PRIMARY KEY (codigo_transacao, codigo_produto)
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)  
GO
CREATE TABLE saida(
codigo_transacao       INT                NOT NULL,
codigo_produto         INT                NOT NULL,
quantidade             INT                NOT NULL,
valor_total            DECIMAL(7,2)       NOT NULL
PRIMARY KEY (codigo_transacao, codigo_produto)
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
) 
GO
DECLARE @codigo   INT,
        @nome     VARCHAR(100),
        @valor    DECIMAL(7,2)
        SET @codigo = 1
        WHILE (@codigo <= 10)
        BEGIN
               SET @valor = ((RAND() * 91) + 10)
            -----------------------------------------------------------------------
               INSERT INTO produto VALUES (@codigo, 'produto'+CAST(@codigo AS VARCHAR(02)), @valor)
               SET @codigo = @codigo + 1
        END  
GO
CREATE PROCEDURE sp_compravenda(@codigo INT, @codigo_produto INT, @nome VARCHAR(100), @valor DECIMAL(7,2),
                                @codigo_transacao VARCHAR(01), @quantidade INT, @saida VARCHAR(200) OUTPUT)
AS
        DECLARE @cod       INT,
                @tabela    VARCHAR(10),
                @query       VARCHAR(200),
                @error     VARCHAR(200),
                @valor_total DECIMAL(7,2)
        set @valor_total = @quantidade * @valor
        BEGIN TRY
               IF @codigo_transacao = 'e'
               BEGIN
                   SET @tabela = 'entrada'
                   SET @cod = CAST(@codigo_produto AS INT)
                   SET @query = 'INSERT INTO '+@tabela+' VALUES('+CAST(@codigo AS VARCHAR(3))+','+CAST(@codigo_produto AS VARCHAR(3))+
                               ','+CAST(@quantidade AS VARCHAR(50))+', '+CAST(@valor_total AS VARCHAR(50))+')'
                   PRINT @query
                EXEC (@query)
               END
               ELSE
            BEGIN
                   IF @codigo_transacao = 's'
                   BEGIN
                       SET @tabela = 'saida'
                       SET @cod = CAST(@codigo_produto AS INT)
                       SET @query = 'INSERT INTO '+@tabela+' VALUES('+CAST(@codigo AS VARCHAR(3))+','+CAST(@codigo_produto AS VARCHAR(3))+
                               ','+CAST(@quantidade AS VARCHAR(50))+', '+CAST(@valor_total AS VARCHAR(50))+')'
                       PRINT @query
                    EXEC (@query)
                   END
            END
        END TRY
        BEGIN CATCH
               SET @error = ERROR_MESSAGE()
               IF (@error LIKE '%primary%')
               BEGIN
                RAISERROR('Codigo invalido', 16, 1)
               END
               ELSE
               BEGIN
                PRINT(@error)
               END  
        END CATCH 
--------------------------------------------------------------------------------------
GO
DECLARE @out1 VARCHAR(200)
EXEC sp_compravenda 13,2, 'Chocolate', 12.52,'s',15, @out1 OUTPUT
PRINT @out1
GO
DECLARE @out1 VARCHAR(200)
EXEC sp_compravenda 1,1, 'Pizza', 5.52,'e',25, @out1 OUTPUT
PRINT @out1
--------------------------------------------------------------------------------------
GO
SELECT * FROM entrada
GO
SELECT * FROM saida 