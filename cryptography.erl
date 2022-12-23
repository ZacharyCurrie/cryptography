%%This Finds, Encrypts, Decrypts and reformats files
-module(cryptography).
-export([stringconvert/1, encrypt_file_location/1, decrypt_file/2, fix_file_name/1,test/0]).



stringconvert(Filenames) ->
	File1 =  filename:absname(Filenames),
	Listed22 = filename:split(File1),
	NS = lists:flatten(io_lib:format("~p",[Listed22])).

encrypt_file_location(NS) ->
	Key = <<1:256>>,
	IV = <<0:128>>,
	Up1 = "<<" ++ NS,
	Up2 = NS ++ ">>",
	AAD = <<>>,
	{CipherText, Tag1} = crypto:crypto_one_time_aead(aes_256_gcm, Key, IV, Up2, AAD, 12, true).
decrypt_file(Egg,Nog) ->
	Key = <<1:256>>,
	IV = <<0:128>>,
	CipherText2 = Egg,
	Tag = Nog,
	AAD = <<>>,
	crypto:crypto_one_time_aead(aes_256_gcm, Key, IV, CipherText2, AAD, Tag, false).

fix_file_name(Fixer) ->
	List = lists:flatten(io_lib:format("~p",[Fixer])),
	Result = [X || X <- List, X =/= $"],
	Result1 = [X || X <- Result, X =/= $<],
	Result2 = [X || X <- Result1, X =/= $>],
	Result3 = [X || X <- Result2, X =/= $#],
	Result4 = [X || X <- Result3, X =/= $\\],
	Result5 = [X || X <- Result4, X =/= $[],
	Result6 = [X || X <- Result5, X =/= $]],
	Result7 = string:replace(Result6, ",", "/"),
	Result8 = filename:join(Result7),
	Result9 = string:tokens(Result8, ","),
	filename:join(Result9).


test() ->
	A = stringconvert(testfile),
	io:format("The File Location Before Ciphered: ~p~n", [A]),
	{CipherText, Tag1} = encrypt_file_location(A),
	io:format("The cipher: ~p~n", [CipherText]),
	B = CipherText,
	C = Tag1,
	Apple = decrypt_file(B,C),
	io:format("Unfiltered Locaiton After decrypting: ~p~n", [Apple]),
	EndGame = fix_file_name(Apple),
	io:format("The File Location Is: ~p~n", [EndGame]).


	
	
	
