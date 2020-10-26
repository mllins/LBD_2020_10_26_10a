CREATE DATABASE Aula_2020_10_26
GO
USE Aula_2020_10_26

create table envio (
CPF varchar(20),
NR_LINHA_ARQUIV	int,
CD_FILIAL int,
DT_ENVIO datetime,
NR_DDD int,
NR_TELEFONE	varchar(10),
NR_RAMAL varchar(10),
DT_PROCESSAMENT	datetime,
NM_ENDERECO varchar(200),
NR_ENDERECO int,
NM_COMPLEMENTO	varchar(50),
NM_BAIRRO varchar(100),
NR_CEP varchar(10),
NM_CIDADE varchar(100),
NM_UF varchar(2)
)

create table endereço(
CPF varchar(20),
CEP	varchar(10),
PORTA	int,
ENDEREÇO	varchar(200),
COMPLEMENTO	varchar(100),
BAIRRO	varchar(100),
CIDADE	varchar(100),
UF Varchar(2))

create procedure sp_insereenvio
as
	declare @cpf as int
	declare @cont1 as int
	declare @cont2 as int
	declare @conttotal as int
	set @cpf = 11111
	set @cont1 = 1
	set @cont2 = 1
	set @conttotal = 1
	while @cont1 <= @cont2 and @cont2 < = 100
	begin
		insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
			values (cast(@cpf as varchar(20)), @cont1,GETDATE())
		insert into endereço (CPF,PORTA,ENDEREÇO)
			values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
		set @cont1 = @cont1 + 1
		set @conttotal = @conttotal + 1
		if @cont1 > = @cont2
		begin
			set @cont1 = 1
			set @cont2 = @cont2 + 1
			set @cpf = @cpf + 1
		end
	end

exec sp_insereenvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc


CREATE PROCEDURE sp_transporta_dados
AS
	DECLARE @cpf			VARCHAR(20),
			@nr_linha		INT,
			@porta			INT,
			@endereco		VARCHAR(200),
			@complemento	VARCHAR(100),
			@bairro			VARCHAR(100),
			@cidade			VARCHAR(100),
			@uf				VARCHAR(2),
			@linha_busca	INT

	DECLARE c_envio CURSOR FOR SELECT cpf, nr_linha_arquiv FROM envio
	OPEN c_envio

	FETCH NEXT FROM c_envio INTO @cpf, @nr_linha
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE c_endereco CURSOR FOR SELECT porta, endereço, complemento, bairro, cidade, uf FROM endereço WHERE cpf=@cpf
		OPEN c_endereco
		FETCH NEXT FROM c_endereco INTO @porta, @endereco, @complemento, @bairro, @cidade, @uf
		SET @linha_busca = 1
		WHILE @@FETCH_STATUS = 0 AND @linha_busca <> @nr_linha
		BEGIN
			SET @linha_busca = @linha_busca + 1
			FETCH NEXT FROM c_endereco INTO @porta, @endereco, @complemento, @bairro, @cidade, @uf
		END
		IF @linha_busca = @nr_linha
		BEGIN
			UPDATE envio SET	NM_ENDERECO = @endereco,
								NM_COMPLEMENTO = @complemento,
								NM_BAIRRO = @bairro,
								NM_CIDADE = @cidade,
								NM_UF = @uf
						WHERE	CPF = @cpf
						AND		NR_LINHA_ARQUIV = @nr_linha
		END
		CLOSE c_endereco
		DEALLOCATE c_endereco
		FETCH NEXT FROM c_envio INTO @cpf, @nr_linha
	END

	CLOSE c_envio
	DEALLOCATE c_envio


EXEC sp_transporta_dados
