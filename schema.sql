drop table public.regiao cascade;
drop table public.concelho cascade;
drop table public.instituicao cascade;
drop table public.medico cascade;
drop table public.consulta cascade;
drop table public.prescricao cascade;
drop table public.analise cascade;
drop table public.venda_farmacia cascade;
drop table public.prescricao_venda cascade;


/* regiao */
create table public.regiao (
	num_regiao integer check(num_regiao > 0) not null,
	nome varChar(1000) not null,
	num_habitantes integer check (num_habitantes > 0) not null,
    primary key(num_regiao),
    unique(num_regiao)
);

/* concelho */
create table public.concelho (
	num_concelho integer check(num_concelho > 0) not null,
	num_regiao integer not null,
	nome varChar(1000) not null,
	num_habitantes integer not null,
	primary key(num_concelho, num_regiao),
	foreign key(num_regiao) references regiao(num_regiao),
    unique(num_concelho)
);

/* instituicao */
create table public.instituicao (
	nome varChar(1000) not null,
	tipo varChar(1000) check(tipo in('farmacia', 'laboratorio', 'clinica', 'hospital')) not null,
	num_regiao integer not null,
	num_concelho integer not null,
	primary key(nome),
	foreign key(num_regiao, num_concelho) references concelho(num_regiao, num_concelho)
);

/* medico */
create table public.medico (
	num_cedula integer check (num_cedula > 0) not null,
	nome varChar(1000),
	especialidade varChar(1000),
    primary key(num_cedula),
    unique(num_cedula)
);

/* consulta */
create table public.consulta(
	num_cedula integer not null,
	num_doente integer check (num_doente > 0) not null,
	data_consulta date check(extract(dow from data_consulta) not in (0,6)) not null,
	nome_instituicao varChar(1000) not null,
	primary key(num_cedula, num_doente, data_consulta),
	foreign key(num_cedula) references medico(num_cedula),
	foreign key(nome_instituicao) references instituicao(nome),
    unique(num_doente, data_consulta, nome_instituicao)
);

/* prescricao */
create table public.prescricao(
	num_cedula integer not null,
	num_doente integer not null,
	data_consulta date not null,
	substancia varChar(1000) not null,
	quant integer check (quant > 0) not null,
	primary key(num_cedula, num_doente, data_consulta, substancia),
	foreign key(num_cedula, num_doente, data_consulta) references consulta(num_cedula, num_doente, data_consulta)
);

/* analise */
create table public.analise(
	num_analise integer check(num_analise > 0) not null,
	especialidade varChar(1000),
	num_cedula integer,
	num_doente integer not null,
	data_analise date,
	data_registo date not null,
	nome varChar(1000) not null,
	quant integer check (quant > 0) not null,
	inst varChar(1000) not null,
	primary key(num_analise),
	foreign key(num_cedula, num_doente, data_analise) references consulta(num_cedula, num_doente, data_consulta),
	foreign key(inst) references instituicao(nome),
	unique(num_analise)
);

/* venda_farmacia */
create table public.venda_farmacia (
	num_venda integer check(num_venda > 0) not null,
	data_registo date not null,
	substancia varChar(1000) not null,
	quant integer check(quant > 0) not null,
	preco integer check(preco > 0) not null,
	inst varChar(1000),
	primary key(num_venda),
	foreign key(inst) references instituicao(nome),
	unique(num_venda)
);

/* prescricao_venda */
create table public.prescricao_venda (
	num_cedula integer not null,
	num_doente integer not null,
	data_prescricao date not null,
	substancia varChar(1000) not null,
	num_venda integer not null,
	primary key(num_cedula, num_doente, data_prescricao, substancia, num_venda),
	foreign key(num_venda) references venda_farmacia(num_venda),
	foreign key(num_cedula, num_doente, data_prescricao, substancia) references prescricao(num_cedula, num_doente, data_consulta, substancia)
);
