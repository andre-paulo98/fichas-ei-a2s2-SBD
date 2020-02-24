/*
O Algoritmo usado na cifragem e decifragem dos dados é o DES, disponível na package DBMS_OBFUSCATION_TOOLKIT
*/
CREATE OR REPLACE FUNCTION FUNC_CIFRAR(input IN VARCHAR2) 
RETURN VARCHAR2 AS
   input_string VARCHAR2(1024) := input;
   ----------Restrições -----------------------------------
   -- A chave tem de ter obriagatoriamente 64 bits (8 bytes)
   -- A string a encriptar tem de ser múltiplo de 8 bytes
   -- A string a encriptar não pode estar vazia
   
   -- Chave utilizada para encriptar a string
   key_string VARCHAR2(8) := 'SBD00708';
   encrypted_string VARCHAR2(2048);

BEGIN
  -- Torna o tamanho da input_string múltiplo de 8    
   input_string := LPAD(input, Length(input) + 8 -  mod(length(input), 8));

  dbms_obfuscation_toolkit.DESEncrypt(input_string => input_string, key_string => key_string,
  encrypted_string=> encrypted_string );  
  RETURN encrypted_string;
  EXCEPTION
    WHEN OTHERS THEN
      return null; 
END FUNC_CIFRAR;
/

CREATE OR REPLACE FUNCTION FUNC_DECIFRAR(input IN VARCHAR2) 
RETURN VARCHAR2 AS
   input_string VARCHAR2(1024) := input;
   ----------Restrições -----------------------------------
   -- A chave tem de ter obriagatoriamente 64 bits (8 bytes)
   -- O tamanho da string a desencriptar tem de ser múltiplo de 8 bytes
   -- A string a desencriptar não pode estar vazia
   
   -- Chave utilizada para encriptar a string
   key_string VARCHAR2(8) := 'SBD00708';
   encrypted_string VARCHAR2(2048) := input;
    decrypted_string VARCHAR2(2048);   
begin

    dbms_obfuscation_toolkit.DESDecrypt(input_string => encrypted_string, 
	key_string => key_string, decrypted_string => decrypted_string );
        
  RETURN LTRIM(decrypted_string);
  
  EXCEPTION
    WHEN OTHERS THEN
      return null; 
END FUNC_DECIFRAR;
/