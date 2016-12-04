
hist = []
histmin = []

funcprot(0)
function [val]= getnumrand(num, jb, op)
    val=-1
    tempo = 0
    while val < 1 & val <= num 
        val = ceil(rand()*num)
        dtjob = listaJobs(jb)
        tempo = dtjob(op,val)
        
        if tempo == 0 
            val=-1
        end
        if val == 0 
            val=-1
        end
    end
endfunction


funcprot(0)
function [listseqjobs, litaoexec] = getFromTempera (numbreak)
    // Implementa a tempera simulada com o intuito de 
    // otimizar a entrada de novos individuos na execução 
    // Gera a solução inicial -- melhor fonte de alimento
    [BFSeqjb, BFListExec]= gen_Foods(1)
    [BFT, BFDtPrint] = calcfitness(BFListExec(1))
    
    melhorsolucao = BFListExec
    binicial = BFListExec
    FitfoodInicial = BFT
    
    IterT = 0 // número de iterações
    IterMAX = 50
    Temperatura = 100
    TempBaixa = 10
    Alpha = 1.1
    
    porc_aceit = 0.95 // Taxa de aceitação para sair do laço 
    taxa_ruim = 0.005 // 5%
    taxa_dim = 0.999
    
    aceitos = 0
    litaoexec = list()
    listseqjobs = list()
    
    foodsaceitos = []
    
    while Temperatura > 0.0001
        rand('seed',getdate('s'))
        
         while IterT <= IterMAX
             [vizinhoSeqjb, vizinhoListExec]= gen_Foods(1)
             
             vizinhoListExec = vizinhoListExec(1)
             vizinhoSeqjb = vizinhoSeqjb(1)
             listaExecucao=  vizinhoListExec
//             seq_job = vizinhoSeqjb
             [FitVizinho, VizinhoDtPrint] = calcfitness2(vizinhoListExec, vizinhoSeqjb)
             
             Delta = FitVizinho - BFT
             
             if Delta < 0 then
                 if FitVizinho <  BFT then 
                     BF = FitVizinho
                     BFListExec = vizinhoListExec
                     foodsaceitos = [ foodsaceitos FitVizinho ]
                     litaoexec($+1) = BFListExec // salva as fontes de alimento encontradas                    
                     listseqjobs($+1) = vizinhoSeqjb
                     aceitos = aceitos +1
//                     hist = [hist FitVizinho ]
                     
//                     printf("Aceitei: fit %d\n", FitVizinho)
                     
//                     if length(foodsaceitos) > numbreak then 
//                       break
//                    end
//                     break
                 end
             else
                 if rand() < (%e^(-Delta/Temperatura)) then
                     BF = FitVizinho
                     BFListExec = vizinhoListExec
                     foodsaceitos = [ foodsaceitos FitVizinho ]
                     litaoexec($+1) = BFListExec // salva as fontes de alimento encontradas                  
                     listseqjobs($+1) = vizinhoSeqjb
//                     listseqjobs($+1) = vizinhoSeqjb
                     aceitos = aceitos +1
                     
//                     hist = [hist FitVizinho ]
//                     printf("Aceitei: fit %d\n", FitVizinho)
//                     printf("Aceito: %d\n", aceitos)
                     if length(foodsaceitos) > (numbreak*4) then 
                       break
                    end
                end
             end
             IterT = IterT + 1
         end


         if aceitos >= (porc_aceit*IterMAX)  then 
             Temperatura = TempBaixa
         elseif aceitos <= (taxa_ruim*IterMAX)
             Temperatura = Temperatura*taxa_dim
         else
             Temperatura = Temperatura*Alpha
         end
         
//         histMin= [histMin min(hist)]
//         plot2d(histMin)
         
         
//         printf("Min: %d\n", min(hist))
         
//         printf("Temperatura: %d\n", Temperatura)

        aceitos = 0
        IterT = 0
//
//        if length(foodsaceitos) > 2000 then // isto permite dar tempo de explorar a vizinhança mesmo que a temperatura não chegue a zero  
            if length(foodsaceitos) > (numbreak*4) then 
            break
        end
    end
//    listaFinal = list()
//    seqfinal = list()
//  
//    
//    melhor = find(hist=min(hist))
//    melhor = melhor(1)
//    listaFinal($+1) = listseqjobs(melhor)
//    seqfinal($+1) = listseqjobs(melhor)
//    
//    final = length(listseqjobs)
//    for i=2:numbreak
//        final = final - 1
//        listaFinal($+1) = listseqjobs(final)
//        seqfinal($+1) = listseqjobs(final)
//    end
//    // Somente melhores individuos 
//    listseqjobs = listaFinal
//    listseqjobs = seqfinal
    
endfunction

funcprot(0)
function [ listaMaqsTempo ]= getMaqs(jb, op, maqAtual)
    // Retorna a lista dos indexes e tempos que terão as máquinas possíveis para um dado job
    
    listaMaqsTempo= [;]
    tempo = 0
    dtjob = listaJobs(jb)
    listamaquinas = dtjob(op,:)
    
    // Só rerá retornado máquinas que tem tempo diferente de zero e diferente da atual 
    cont=1
    for i=1:length(listamaquinas)
        tempo = listamaquinas(i)
        if ceil(tempo) ~= 0 & i ~= maqAtual & i <= num_maq then 
//            printf("Inserindo : %d tempo %d\n", i, tempo)
            listaMaqsTempo(cont,:) = [i tempo]
            cont=cont+1
        end
    end
endfunction

funcprot(0)
function maqexec = getMaq(jb, op, maqAtual)
//    try
//    printf("Job %d op %d mq %d\n", jb, op, maqAtual)
       listaMaqsTempo = getMaqs(jb, op, maqAtual)
       listaMaqsTempo = listaMaqsTempo(:,1)
//       while maqexec <= num_maq
    tam = length(listaMaqsTempo)
     qual = ceil(rand()*tam)
    linhaExec = listaMaqsTempo(qual)
    maqexec = linhaExec(1)
//       end

//        printf("Maq %d \n",maqexec )
//    catch
//        maqexec = maqAtual
//    end
    
endfunction


funcprot(0)
function matdif =  montaDiffs(lToPrintBetter)
    matdif =[;]
    
    for i=1:num_jobs
        opsJob = op_jobs(i)
        for j=1:(opsJob-1)
            linhaOpAt = find(lToPrintBetter(:,2)==i & lToPrintBetter(:,3)==j)
            linhaOpProx = find(lToPrintBetter(:,2)==i & lToPrintBetter(:,3)==(j+1))
            
            fimFirst = lToPrintBetter(linhaOpAt(1),5)
            inicioSecond = lToPrintBetter(linhaOpProx(1),4)
            
            dif =  inicioSecond - fimFirst
            
            maq = lToPrintBetter(linhaOpProx(1),1)
            
            // considera-se que 1 seja um número aceitável 
            if dif > 1 then 
                [lMt,cdsdf] = size(matdif)
                matdif((lMt+1),:) = [i (j+1) maq]
            end
        end
    end
endfunction

funcprot(0)
function [exclistAt, dataprintseqNewInit] = otimizaWorst (comida)
    // Uma tentativa de otimizar baseando-se no espaço entre as operações
    exclistAt = comida
    exclist = comida
    [fitnessInicial, dataprintseqNewInit] = calcfitness(exclistAt)
//    printf("Ok1\n")
    matdif =  montaDiffs(dataprintseqNewInit)
//    printf("Ok2\n")
    [l,c] = size(matdif)
    for i=1:l
//        try
          jobOpt = matdif(i,1)
          opOpt = matdif(i,2 )
          maqOpt = matdif(i,3 )
//          printf("Job %d op %d maq %d\n",jobOpt, opOpt,maqOpt)
          // Pega as máquinas que podem executar a tarefa de maneira aleatória
//          if jobOpt == 0 then 
//                continue
//            end
            
            newMaq = getMaq(jobOpt, opOpt, maqOpt)
         
            // Avalia a nova solução
            exclist = change_machine(exclist, jobOpt, opOpt, newMaq)
//            printf("Machine change %d to %d\n",maqOpt, newMaq )
            [fitnessNew, dataprintseqNew] = calcfitness(exclist)
            
            res = (dataprintseqNewInit == dataprintseqNew)
            fres = find(res==%T) // Procura para verificar há algum valor true 
            if length(fres) ~= 0 & fitnessNew <= fitnessInicial then
                exclistAt = exclist
                dataprintseqNewInit = dataprintseqNew
//                printf("Consegui mudar a configuração de %d para %d \n", fitnessInicial, fitnessNew)
    //            break
            end
//        catch
//            b=1
//        end
        
        
//        printf("Sem sucesso!!! %d\n ",i)
    end
    
endfunction




funcprot(0)
function find0(lista,num)
    
    for i=1:length(lista)
        
        taskOps = lista(i)
        for j=1:length(taskOps)
            if taskOps(j) == 0
                printf("Atenção, encontrei um 0  num %d\n", num)
            end
        end
    end
endfunction

funcprot(0)
function gera_grafico_gantt (dataprintseq)
    colorst =  ['blue', 'red', 'green', 'yellow','cyan', 'magenta', 'gray44', 'gray', 'purple3', 'blue', 'light green', 'thistle1', 'plum4', 'violetred4', 'lightpink4']
    
    [l,c] = size(dataprintseq)
    data1 = zeros(num_maq,1)
    barh(data1, "stacked")
    
    labels = list()
    //abort
    while l ~= 0
        // primeiro é sempre o último
        maior = dataprintseq(1,5)
        indexmaior = 1
        inicio = dataprintseq(1,4)
        for i=1:l
            linha = dataprintseq(i,:)
            
            if linha(5) >= maior
                maior = dataprintseq(i,5)
                inicio = dataprintseq(i,4)
                indexmaior = i
            end
        end
        
        // gera zeros para gerar uma Barra 
        data1 = zeros(num_maq,1)
        data2 = zeros(num_maq,1) // do antes que, sempre será cinza para representar o tempo parado
        
        maqat = dataprintseq(indexmaior,1)
        data1(maqat) = maior
        data2(maqat) = inicio // area sombreada
        
        x = maqat - 0.25 // posição do label em X
        y = maior - ((maior - inicio)/2) // na metade entre o inicio e o fim
        
        
        task = dataprintseq(indexmaior,2)
        operacao = dataprintseq(indexmaior,3)
        cortask = colorst(task)
        printf("Cor %s \n", cortask)
        labelstr = ""+string(task)+","+string(operacao)+""
        tirar = length(labelstr)/2
        y = y - (tirar/3)
        
//        printf("Cortask: %s\n", cortask)
        barh(data1, "stacked")
        e = gce()
        p1 = e.children(1)
        p1.background  = color(cortask)
        
        b = barh(data2,  'white', "stacked") // idle time 
//        printf("oi\n")
        b.EdgeColor = 'none'
    //    xstring(y,x, labelstr)
        
        labels($+1) = [y, x,  task, operacao ]  
        // remove o index maior 
        dataprintseq(indexmaior,:) = {}
        
        [l,c] = size(dataprintseq)
    end
    
    
    xlabel('Tempo');
    ylabel('Máquinas');
    title('Gráfico de Gantt');
    
    for i=1:length(labels)
        lb = labels(i)
        str = ""+string(lb(3))+","+string(lb(4))
//        str = ""+string(lb(3))
        xstring(lb(1), lb(2), str)
    end
    

    
endfunction


funcprot(0)
function [fitness, dataprintseq] = calcfitness(lista)


    fitness=0
    dataprintseq = [;]
    
    // Lista com tempos de execução de cada Máquina
    // Cada lista vai crescendo de acordo com que se vai 
    seqExecucao = list()
    for i=1:num_maq
       seqExecucao($+1) = list()
    end
    
    
    // Cria o timeJobs -- tempo que termina a última tarefa. 
    timeJobs = list()
    for i=1:length(seq_job)
       timeJobs($+1) = list()
    end
    
    
    //printf("Maquina;jb;op;inicio;fim\n") 
    // Comepa-se a preencher com os tempos iniciais e finais na respectiva máquina
    for i=1:length(seq_job)
        jb =  seq_job(i)
//        printf("Job %d len listaexecucação %d\n", jb, length(lista))
        maquinasJobs = lista(jb)
        
        for mascsIND=1:length(maquinasJobs)
            mac_for_JOB = maquinasJobs(mascsIND)
            operacaoJOB = mascsIND
            tableOPERACOES = listaJobs(jb)
            tempo_to_OP = tableOPERACOES(operacaoJOB, mac_for_JOB) // tempo para executar uma operação 
            listaSeq = seqExecucao(mac_for_JOB)
            
            [lDt, cDt] = size(dataprintseq)
            
            // Se a lista estive vazia e a operacao for a primeira, então só joga-se o valor na lista
            if length(listaSeq) == 0 & operacaoJOB == 1 
    //            printf("if1\n")
    //            printf("Maquina %d jb %d op: %d inicio %d fim %d \n",mac_for_JOB, jb, operacaoJOB,0, tempo_to_OP)
    //            printf("%d;%d;%d;%d;%d\n",mac_for_JOB, jb, operacaoJOB,0, tempo_to_OP)
                
                dataprintseq((lDt+1),:) = [mac_for_JOB  jb operacaoJOB,0, tempo_to_OP]
                
                ljob = timeJobs(i)
                ljob($+1) = tempo_to_OP
                timeJobs(i) = ljob
                
                listaSeq($+1) = [jb, operacaoJOB,0, tempo_to_OP] 
                
                // update fitness
                if tempo_to_OP > fitness
                    fitness = tempo_to_OP
                end
            elseif operacaoJOB == 1 
                // Procura somente o tempo do index anterior e este é o seu tempo inicial
                tam = length(listaSeq)
                last = listaSeq(tam)
                tempoLast = last(4)
                listaSeq($+1) = [jb, operacaoJOB,tempoLast, (tempo_to_OP + tempoLast)]
                
                ljob = timeJobs(i)
                ljob($+1) = (tempo_to_OP + tempoLast)
                timeJobs(i) = ljob
    //            
    //            printf("if2\n")
    //            printf("Maquina %d jb %d op: %d inicio %d fim %d \n",mac_for_JOB, jb, operacaoJOB,tempoLast,  (tempo_to_OP + tempoLast))            
                dataprintseq((lDt+1),:) = [mac_for_JOB, jb operacaoJOB,tempoLast  (tempo_to_OP + tempoLast)]
    //            printf("%d;%d;%d;%d;%d\n",mac_for_JOB, jb, operacaoJOB,tempoLast,  (tempo_to_OP + tempoLast)) 
    
                   // update fitness
                if (tempo_to_OP + tempoLast) > fitness
                    fitness = (tempo_to_OP + tempoLast)
                end
              else
            
                // Procura somente o tempo do index anterior e este é o seu tempo inicial
                tam = length(listaSeq)
                
                ljob = timeJobs(i)
                lastTamJob = length(ljob)
                inicionext = 0
                
                if tam > 0
                    last = listaSeq(tam)
                    tempoLast = last(4) // o tempo do row corrente
                    
                    // pega o fim do último tempo de um Job em específico
                    valLastJob = ljob(lastTamJob)
                    inicionext = max([tempoLast valLastJob])
//                     printf("Inicionext1: %d\n", inicionext)
                else
                    // pega o fim do último tempo de um Job em específico
                    valLastJob = ljob(lastTamJob)
                    inicionext = valLastJob
//                    printf("Inicionext2: %d\n", inicionext)
                end
                
                ljob($+1) = (tempo_to_OP + inicionext)
                timeJobs(i) = ljob
                
                listaSeq($+1) = [jb, operacaoJOB, inicionext, (tempo_to_OP + inicionext)]
                
//                printf("Maquina %d jb %d op: %d inicio %d fim %d \n",mac_for_JOB, jb, operacaoJOB, inicionext,  (tempo_to_OP + inicionext))
                dataprintseq((lDt+1),:) = [mac_for_JOB, jb, operacaoJOB, inicionext,  (tempo_to_OP + inicionext)]
                
                  // update fitness
                if (tempo_to_OP + inicionext) > fitness
                    fitness = (tempo_to_OP + inicionext)
                end
            end
            seqExecucao(mac_for_JOB) = listaSeq
        end
    end
endfunction

function [fitness, dataprintseq] = calcfitness2(lista, localseq)


    fitness=0
    dataprintseq = [;]
    
    // Lista com tempos de execução de cada Máquina
    // Cada lista vai crescendo de acordo com que se vai 
    seqExecucao = list()
    for i=1:num_maq
       seqExecucao($+1) = list()
    end

    // Cria o timeJobs -- tempo que termina a última tarefa. 
    timeJobs = list()
    for i=1:length(localseq)
       timeJobs($+1) = list()
    end

    //printf("Maquina;jb;op;inicio;fim\n") 
    // Comepa-se a preencher com os tempos iniciais e finais na respectiva máquina
    for i=1:length(localseq)
        jb =  localseq(i)
//        printf("Job %d len listaexecucação %d\n", jb, length(lista))
        maquinasJobs = lista(jb)
        
        for mascsIND=1:length(maquinasJobs)
            mac_for_JOB = maquinasJobs(mascsIND)
            operacaoJOB = mascsIND
            tableOPERACOES = listaJobs(jb)
            tempo_to_OP = tableOPERACOES(operacaoJOB, mac_for_JOB) // tempo para executar uma operação 
            listaSeq = seqExecucao(mac_for_JOB)
            
            [lDt, cDt] = size(dataprintseq)
            
            // Se a lista estive vazia e a operacao for a primeira, então só joga-se o valor na lista
            if length(listaSeq) == 0 & operacaoJOB == 1 
    //            printf("if1\n")
    //            printf("Maquina %d jb %d op: %d inicio %d fim %d \n",mac_for_JOB, jb, operacaoJOB,0, tempo_to_OP)
    //            printf("%d;%d;%d;%d;%d\n",mac_for_JOB, jb, operacaoJOB,0, tempo_to_OP)
                
                dataprintseq((lDt+1),:) = [mac_for_JOB  jb operacaoJOB,0, tempo_to_OP]
                
                ljob = timeJobs(i)
                ljob($+1) = tempo_to_OP
                timeJobs(i) = ljob
                
                listaSeq($+1) = [jb, operacaoJOB,0, tempo_to_OP] 
                
                // update fitness
                if tempo_to_OP > fitness
                    fitness = tempo_to_OP
                end
            elseif operacaoJOB == 1 
                // Procura somente o tempo do index anterior e este é o seu tempo inicial
                tam = length(listaSeq)
                last = listaSeq(tam)
                tempoLast = last(4)
                listaSeq($+1) = [jb, operacaoJOB,tempoLast, (tempo_to_OP + tempoLast)]
                
                ljob = timeJobs(i)
                ljob($+1) = (tempo_to_OP + tempoLast)
                timeJobs(i) = ljob
    //            
    //            printf("if2\n")
    //            printf("Maquina %d jb %d op: %d inicio %d fim %d \n",mac_for_JOB, jb, operacaoJOB,tempoLast,  (tempo_to_OP + tempoLast))            
                dataprintseq((lDt+1),:) = [mac_for_JOB, jb operacaoJOB,tempoLast  (tempo_to_OP + tempoLast)]
    //            printf("%d;%d;%d;%d;%d\n",mac_for_JOB, jb, operacaoJOB,tempoLast,  (tempo_to_OP + tempoLast)) 
    
                   // update fitness
                if (tempo_to_OP + tempoLast) > fitness
                    fitness = (tempo_to_OP + tempoLast)
                end
              else
            
                // Procura somente o tempo do index anterior e este é o seu tempo inicial
                tam = length(listaSeq)
                
                ljob = timeJobs(i)
                lastTamJob = length(ljob)
                inicionext = 0
                
                if tam > 0
                    last = listaSeq(tam)
                    tempoLast = last(4) // o tempo do row corrente
                    
                    // pega o fim do último tempo de um Job em específico
                    valLastJob = ljob(lastTamJob)
                    inicionext = max([tempoLast valLastJob])
//                     printf("Inicionext1: %d\n", inicionext)
                else
                    // pega o fim do último tempo de um Job em específico
                    valLastJob = ljob(lastTamJob)
                    inicionext = valLastJob
//                    printf("Inicionext2: %d\n", inicionext)
                end
                
                ljob($+1) = (tempo_to_OP + inicionext)
                timeJobs(i) = ljob
                
                listaSeq($+1) = [jb, operacaoJOB, inicionext, (tempo_to_OP + inicionext)]
                
//                printf("Maquina %d jb %d op: %d inicio %d fim %d \n",mac_for_JOB, jb, operacaoJOB, inicionext,  (tempo_to_OP + inicionext))
                dataprintseq((lDt+1),:) = [mac_for_JOB, jb, operacaoJOB, inicionext,  (tempo_to_OP + inicionext)]
                
                  // update fitness
                if (tempo_to_OP + inicionext) > fitness
                    fitness = (tempo_to_OP + inicionext)
                end
            end
            seqExecucao(mac_for_JOB) = listaSeq
        end
    end
endfunction














// Confiugrações do algoritmo genético 
tamanhopop = 200
populacao = [;]



// 4 tarefas 
op_jobs = fscanfMat("op8x8.txt");
tempo_jobs = fscanfMat("tempos8x8.txt");
listaPop = list()

// Gera um configuração possível 
num_jobs = length(op_jobs)
[l,num_maq] = size(tempo_jobs)

maxop = max(num_jobs)

runtime = 50; // O algoritmo pode ser executado diversas vezes a fim de avaliar a robustes

//printf("Num maq: %d\n", num_maq)

// lista ORIGINAL de maneira estruturada os jobs dos arquivos 
listaJobs = list()
indexglobal = 1
for i=1:num_jobs
    atJob = list()
    dataJob = [;]
    taskl = []
    
    // num atividades 
    atividade = op_jobs(i)
    for j=indexglobal:(indexglobal+atividade)-1
        [lT,cT] = size(dataJob)
//        printf("J: %d\n", j)
        dataJob((lT+1),:) = tempo_jobs(j,:)
    end
    listaJobs($+1) = dataJob
    
    indexglobal = indexglobal + atividade
end

global = [;]

fitness = 0

// define uma sequência aleatória tendo como base a quantidade de jobs


// machines already selected 
machineSel = []
custoTempoTasks = [] 

// Sequência randômica dos jobs - Inicial 
seq_job = grand(1, "prm", (1:num_jobs)')';


funcprot(0)
function listaExecucao = getlistExec(seq_job)
        listaExecucao = list()
        
         p = 0.6
         r = rand()
        
        listaAleat = list()
        listaMin = list()
        
        for j=1:length(seq_job)
           listaExecucao($+1) = list()
//           listaAleat($+1) = list()
//           listaMin($+1) = list()
        end

        // Para cada Job um index de máquina é gerado
        for job=1:length(seq_job)
           jb =  seq_job(job)
           ok = 0
          // Define a sequência de execução da máquina para cada operação
           op_at_job = op_jobs(jb)
           mTask = []
            if r <= p then
               for j=1:op_at_job
                   machineSelExecutetask =getnumrand (num_maq,jb,j) 
                   
                   if machineSelExecutetask == 0
                        printf("Foi selecionado 0 \n")
                   end
                   
                   mTask($+1) = machineSelExecutetask
               end
               listaExecucao(jb) = mTask
           else
                
               // Gera a configuração de acordo com as máquinas que contém o menor tempo e compara com a abordagem aleatória. O que assegura a melhor configuração
    //           
               datajob = listaJobs(jb)
               mtaskmin = []
               for opi=1:op_at_job
                   // procura a máquina com o menor tempo para esta atividade
                   linhaop = datajob(opi,:)
                   
                   // elimina os zeros
                   for j=1:length(linhaop)
                        if linhaop(j) == 0
                            linhaop(j) = 100000000000000 // joga-se um valor muito alto para excluir cada index com valor 0
                        end
                   end
                   menor = min(linhaop)
                   mIndex = find(linhaop==menor,1)
                   mtaskmin($+1) = mIndex
    //               printf("\nJob: %d com op %d\n", jb, opi)
    //               printf("index min: %d\n",mIndex)
    //               printf("Tempo menor %d\n", menor)
           end
           listaExecucao(jb) = mtaskmin
           end
//           listaAleat(jb) = mTask
//           listaMin(jb) = mtaskmin
           
//           
        end

//         
//         if r <= p then
//             listaExecucao = listaAleat
//         else
//             listaExecucao = listaMin
//         end
endfunction

funcprot(0)
function [listseqjobs, litaoexec]= gen_Foods(tamPop)
    listseqjobs = list()
    litaoexec = list()
    rand('seed',getdate('s'))
    for i=1:tamPop
        // Sequência de execução dos jobs
        seq_job = grand(1, "prm", (1:num_jobs)')';
//        printf("Num jobs: %d\n", num_jobs)
        
        listseqjobs($+1) = seq_job
        listaExecucao = getlistExec(seq_job)
     
//        printf("Listaexecução : %d\n", length(listaExecucao))
        
        litaoexec($+1) = listaExecucao
    end
endfunction

funcprot(0)
function pornografico()
    gera_grafico_gantt(lastToPrintBetter)
endfunction



// AQUI COMEÇA A METAHEURISTICA


// Parâmetros de controle do Algoritmo ABC 
NP = 2*num_maq // Tamanho da colônia = (abelhas empregadas + abelhas espectadoras)
D = num_maq // o número de parâmetros do problema a ser otimizado 
maxCycle =  50 
FoodNumber = maxCycle // quantidade de fontes de alimento é igual ao tamanho da metade da colônia
limit = 5 // Uma fonte de alimento no qual poderá ser melhorado por meio do limite de triais e abandonado pelos seus empregados 
// O número de ciclos por farrogeamento -- critério de parada
Nse = ceil(num_maq/2) 

runtime = 10000 // o algoritmo pode ser executado diversas vezes a fim de avaliar sua robustez 
GlobalMins=zeros(1,runtime)

function [fitnessl, printseql]=list_fitess(listseqjobs,litaoexec )
      fitnessl = list()
      printseql = list()
      
      tamlist = length(litaoexec)
      
//      printf("Lenseq: %d\n", length(listseqjobs))
      
      for i=1:tamlist
          
         myseqjob = listseqjobs(i)
         listaExecucao = litaoexec(i)
         [fitness, dataprintseq] = calcfitness2(listaExecucao, myseqjob)
//          printf("Fitness: %d\n", fitness)
          fitnessl($+1) = fitness
          printseql($+1) = dataprintseq
      end
      fitnessl = list2vec(fitnessl)
endfunction
listaNew =list()
ops_task = []
l = list()
// Faz uma checagem adicional em relação a quantidade de operações por máquina
function listaNew = change_machine(listaJobs, job, operacao, newMachine)
    listaNew = listaJobs
  
    ops_task = listaNew(job)
    
    // checa se o tamanho está ok
    numop = op_jobs(job)
   
    if length(ops_task) < numop then
//        printf("Tamanho antigo: %d\n", length(ops_task))
//         printf("JOb: %d\n", job)
        // Regerar a sequência de máquinas de um 
        ops_taskN = [;]
        
//        listaNew(job) =[0, 0, 0, 0, 0, 0, 0,0,0,0,0,0 ] 
        for i=1:numop
            [l,c] = size(ops_taskN)
            final = c+1
            if i == operacao
                ops_taskN(1,final) = newMachine
            else
                last =  getnumrand(num_maq, job, i)
                // regera as outras máquinas 
//                printf("Last : %d\n", last)
                ops_taskN(1,final) = last
            end
        end
        
        for i=1:length(listaJobs)
            if i == job
//                printf("Tamanho: %d\n", length(ops_taskN))
                listaNew(job) = ops_taskN
            else
                linha = listaJobs(i)
                listaNew(i) = listaJobs(i)
            end
        end
    else
        ops_task(operacao) = newMachine
        listaNew(job) = ops_task
    end
    listaNew(job) = ops_task
    
    // verifica a modificação 
    
endfunction

// verifica se com a modificação de uma máquina obteve-se alguma diferença no tempo final do JOB
function result = verifica(printjobOld, printjobnew, job) // 1 -- melhorou e 0 -- não melhorou 
    result = 0 
    tempoOld = 0 // MaxTime
    tempoNew = 0 
    maxtime = 0
    
    // percorre a lista lastToPrintBetter para montar os tempos de cada máquina
    [lbetter, cbetter] = size(printjobOld)
    for lb=1:lbetter
        // maq job op inicio fim ---- lastToPrintBetter
        if job == printjobOld(lb,2) then
            fim=5
            tmp = printjobOld(lb,fim)
            
            if tmp >= tempoOld then 
                // Update Time
                tempoOld = tmp
            end
        end
        
        // C
        if job == printjobnew(lb,2) then
            fim=5
            tmp = printjobnew(lb,fim)
            
            if tmp >= tempoNew then 
                // Update Time
                tempoNew = tmp
            end
        end
    end
    
    if tempoNew < tempoOld then
        result = 1
//        printf("Melhorou o tempo -- TempoNew %d e TempoOld %d\n", tempoNew, tempoOld)
    end
endfunction



funcprot(0)
function listaLivres = getFree(listprint)
     // Cria uma lista de espaços livres para uma dada fonte de alimento
     listaLivres = list()
     for lFree=1:num_maq // lista de espaços livres de uma dada máquina
        listaLivres($+1) = list()
     end
     // Preenche os espaços vazios 
     for lMq=1:num_maq
         linhasmymdaq = find(listprint(:,1)==lMq) // ids das ops que estão na máquina
         livres = [0:(BestFitness)] // lista de espaços livres .... começa do zero  pq  é assim que começa no gráfico 
//         printf("\n\nEspaços livres da máquina: %d\n", lMq)
         toRem = []
         for maqat=1:length(linhasmymdaq)
             hasSet = 0
             linha = linhasmymdaq(maqat)
             if hasSet == 0 then
                inicio = listprint(linha,4)
             end

              // encontro de Blocos devem ser removidos 
             a=1
             ini=0
             Fim=0
             try
                 
                 px = linhasmymdaq((maqat+1))
                 ini = listprint(linha,5)
                 Fim = listprint(px,4) // início do próximo
                 
                 if ini == Fim then 
                    a=0
                 end
             catch
                 a = 1 //~ serve pra nada 
             end
             if inicio ~= 0 & a==0 & hasSet == 0 then 
                inicio = listprint(linha,4) + 1
//                printf("PAREI AQUIIIIIIiii!!!!!!\n")
//                printf("Linha: %d\n", linha)
                hasSet = 1
             end
             
             if maqat == length(linhasmymdaq) then
                fim  = listprint(linha,5) - 1
//                printf("First \n")
             else 
//                 printf("Second\n")
                 fim = listprint(linha,5)
             end

             if listprint(linha,5) == BestFitness then 
                fim = listprint(linha,5)+1
                
//                printf("O FIM É IGUAL AO FITNESS\N")
             end
             
             if ini ~= Fim then 
                fim = listprint(linha,5) - 1
//                printf("TEM O PRÓXIMO, MAS NÃO É O ÚLTIMO\n")
                     //fitIni
                if fim==1 & hasSet == 0 then 
                    inicio = listprint(linha,4) + 1
                    hasSet = 1
                end
//                printf("Inicio: %d\n", inicio)
             end
             
             intervaloTestOperacao =[inicio:fim]
             
             for toad=1:length(intervaloTestOperacao)
                 toRem($+1) = intervaloTestOperacao(toad)
             end

         end

         // Remove os elementos já preenchidos da lista de livres
         for tr=1:length(toRem)
             try
                placer = find(livres==toRem(tr))
                placer = placer(1)
                livres(placer) = {}
              catch
                  b="asdfasdf" // qualquer coisa rsrs
              end
         end
         
         if length(livres) == 1 then 
             
             livres(1) = {}
         end
         
////         
//          printf("Resultado\n")
//         for lvid=1:length(livres)
//            printf("%d ",livres(lvid))
//         end
         
         intervLivre = [;]
         
         // Monta uma sequência de intervalos livres para que seja mais fácil a procura por um e despaço disponível para a inserção de uma operação 
            
        while length(livres) ~= 0
            sequencia = []
            first = livres(1)
            sequencia($+1) = first
            
            livres(1) = {}
            intervaloPointer = first + 1  // sempre aponta para o próximo 
            
            hasNext = find(livres==intervaloPointer)
            
            if length(hasNext) == 0 then 
                // Se não tiver nenhum -- então pula-se
                dif = intervaloPointer - first
                // Pula quando a diferença é 0 -- não pode ter um intervalo com apenas um elemento 
                if dif == 1 then 
                    continue
                else
                    // Adiciona e remove 
                    intervLivre($+1,:) = [first intervaloPointer (intervaloPointer-first)] // Início do intervalo e fim do intervalo
                    livres(1) = {}
                end
            else
                // Já que tem o próximo procura por todas as sequências a partir do ID encontrado 
                encontrouNovo = 1
                cont = 1
                fim = intervaloPointer
                while encontrouNovo == 1 
                    atual = livres(1)
                    
                    // Se for igual só atualiza e remove 
                    if atual == intervaloPointer then 
                        intervaloPointer = intervaloPointer + 1
                        fim = atual // guarda o último
                        livres(1) = {}
                    else
                        encontrouNovo = 0
                        dif = fim - first
                        
                        intervLivre($+1,:) = [first fim dif]
                    end
                end
            end 
        end
        
        // remove os zeros 
        tRem = find(intervLivre(:,3)==0)
        
        for i=1:length(tRem)
            id = tRem(i)
            intervLivre(id,:) = {}
        end

        listaLivres(lMq) = intervLivre
     end
endfunction

funcprot(0)
function [ tmLastInit, tmLastFim ]=  getTime (mt, jb, op)
     //  Argumentos: 
     //             mt -- matriz no formato printseqbestplace
     //             jb - atual , op - atual e maq - nova maquina
     opIni = op
    if op == 1 then
        matJob = listaJobs(jb)
        idConfAtual = find(mt(:,2)==jb & mt(:,3)==op)
    else // Pega o ID da atividade anterior a atual
        op = op - 1
        idConfAtual = find(mt(:,2)==jb & mt(:,3)==op)
    end

    
    tmLastInit = mt(idConfAtual,4) // tmp inicial
    tmLastFim = mt(idConfAtual,5) // tmpFinal
    
//    
//    // zera para possibilitar 
//    if tmLastInit == 0  then 
//        tmLastFim = 0
//    end
//    

endfunction


function [listaExecucao,lastToPrintBetter ] =  melhorarWorst(lst, lstPrintBetter)
    listaExecucao = lst
    lastToPrintBetter = lstPrintBetter
    [ftNewI, dtseqNew] = calcfitness(lst) 
    lastToPrintBetter = dtseqNew
//    printf("Primeiro fitness %d\n", ftNewI)
    sair=0
    
    MaxMelhorar = ceil(rand()*num_maq) // qual dos piores será melhorado 
    
    // Tenta todas as atividades 
    for i=1:num_jobs // 8 jobs 
        worstList = list()
        
        worstInit = max(lastToPrintBetter(:,5))
        pior = worstInit
        contfind = 1
        while length(worstList) <= num_maq 
            piorToAdd = find(lastToPrintBetter(:,5)==worstInit)
            
            if length(piorToAdd) ~= 0 then 
                worstInit = worstInit - 1
                worstList($+1) = piorToAdd(1)
            end

            contfind = contfind +1 
            
            if contfind > 20 then 
                break
            end
            
        end
        
//        printf("Melhorarei o %dº pior  t worst: %d\n", MaxMelhorar, length(worstList))
        
        if contfind > 20 then 
            pior = worstList(1)
        else
            pior = worstList(MaxMelhorar)
        end
        
        
        
        // Procura a máquina que tem o maior os 3 maiores fitness e o seleciona para melhorar 
        maistempoID = find(lastToPrintBetter(:,5)==pior)
        
        // Caso haja mais de 1 indivíduo com o maior fitness
//        qualEscolher = ceil(rand()*length(maistempoID))
        maistempoID = maistempoID(1)
        
        maq = lastToPrintBetter(maistempoID,1)
        opsMaq = find(lastToPrintBetter(:,1)==maq) 
        
        // Pega todas as operações deste Job 
        for j=1:length(opsMaq)
            linha = opsMaq(j)
            job = lastToPrintBetter(linha,2)
            quantOps = find(lastToPrintBetter(:,2)==job)
            
            for k=1:length(quantOps)
                // Procura por uma op K e tenta otimizá-la 
                // considera-se otimizado quando o fitness é menor ou igual ao que foi obtido anteriormente 
                [listaExecucaoAfter, dtseqNew, tipo, ftNew]=findFitMachine(listaExecucao, job, k)
                [ftNew, dtseqNew] = calcfitness(listaExecucaoAfter) 
        
                if ftNew <= ftNewI then 
                    ftNewI  = ftNew
                    listaExecucao = listaExecucaoAfter
                    lastToPrintBetter = dtseqNew
                    
                    
                    if ftNew < ftNewI then
                        sair=1
                        printf("Melhorei para %d\n", ftNew)
                        break
                    end
                     
                end
            end
            if sair==1 then 
                break
            end
            
        end
        
        if sair==1 then 
            break
        end
        
    end
endfunction


funcprot(0)
function [listaOtimizada, dataprintseqBestPlace, tipo, fitnessNew]=findFitMachine(listaExc, jobSel, opSel)
    numLoc = -1
    
    
    // Conceitua-se best o lugar que deixa o lugar com o menor tempo
    // Aqui pode ser melhor fit ou o wors (pior) encaixe
    [fitnessBestPlace, dataprintseqBestPlace] = calcfitness(listaExc)
    fitnessNew = fitnessBestPlace
    dataPrintFirstplace = dataprintseqBestPlace
    livres = getFree(dataprintseqBestPlace)
    jobl = listaExc(jobSel)
    maquina =  jobl(opSel) // máquina atualmente utilizada
    
    // Por padrão a lista não será modificada 
    listaOtimizada = listaExc
    
    bestOrWorst = ceil(rand()*3) // 1 Best Fit -- menor espaço | 2 - worst fit -- maior espaço  | 3 --FirstFIT | 4 - FirstMustBe Optimized
    
    // Tempo da máquinao m
    dtjob = listaJobs(jobSel)
    temposMaqs = dtjob(opSel,:)
    tempoAtual = temposMaqs(maquina)
    
    // Tempo inicial e tempo final 
    id = find(dataprintseqBestPlace(:,2)==jobSel & dataprintseqBestPlace(:,3)==opSel)
    inicioAtual = dataprintseqBestPlace(id,4)
    fimAtual = dataprintseqBestPlace(id,5)
    
    // Pega as máquinas que podem executar um dado job e uma operação 
    [ listaMaqsTempo ]= getMaqs(jobSel, opSel, maquina)

    
    // Com o menor tempo
    tmp = listaMaqsTempo(:,2) // Somente os tempos -- exceto da máquina que já está sendo usada 
    maqs = listaMaqsTempo(:,1)
    mintmp = min(tmp) // menor tempo
    tmpF = find(tmp==mintmp) // procura o menor tempo
    menorTmaqAleat = ceil(rand()*length(tmp)) // de acordo com o tamanho, escolhe-se o melhor lugar, pois caso haja um que tenha o tempo igual o find retornará mais de um id 
    
    
    // BEST FIT
    // É o best fit o que deixa o que tem o menor tempo 
        // a quantidade de tempo necessária para a execução da atividade deve ser igual ou superior ao que se deseja
        // o desperdício de tempo deve ser mínimo 
        // o início da atividade deve ser menor ou igual ao atual
    
    // Procura nas máquinas por um local que o início seja menor ou igual
    
//    can = ceil(rand()*3)

    listaMaqPos = [] // lista de tempos usados em cada máquina 
    tipo="generico"
    bestTimefit = 100000000000
    if (bestOrWorst == 1) then 
        gapBetter = 10000000000000 // o burado deve menor ou igual
//        printf("BESTFIT\n")
        tipo = "BESTFIT"
    elseif bestOrWorst == 2 then
        gapBetter = 0 // o burado deve ser maior ou igual para ser melhor
        tipo = "WORSTFIT"
//        printf("WORSTFIT\n")
    elseif bestOrWorst == 4 & can == 1 then
         [listaOtimizada, dataprintseqBestPlace] = otimizaWorst (listaExc)
         tipo = "PIORLOCALIZADO"
         [fitnessNew, dataprintseqBestPlace] = calcfitness(listaOtimizada)
//         printf("PIORLOCALIZADO \n")
         
    else
        gapBetter =10000000000000000
        tipo = "FIRSTFIT"
//        printf("FIRSTFIT\n")
    end
    
    bestFitID = 1
    bestFitIDlivre = 1
    
    // Pega o tempo inicio e Fim da última máquina se a operação for maior que 1 
    // Quando definido isto, preferencialmente deseja-se que o início seja a melhor posição 
    
    // As operações 1 devem ser preferenciais para o início, o que possibilita a otimização da tarefa 
    [ tmLastInit, tmLastFim ]=  getTime (dataprintseqBestPlace, jobSel, opSel)
     
    newMaq = maquina // Só melhorou se for diferente da anterior, desta forma, quando 
    difLast = tmLastFim - tmLastInit
    
    sair = 0
    // First must be First
    
    
    
   
    // Procura em todas as máquinas por 
    for i=1:length(tmp)
        
        if bestOrWorst == 4 then
            break
        end
        
        
        mq = maqs(i)
        libres = livres(mq)
        // Tempo requerido para executar esta tarefa nesta máquina 
        // Tempo da máquinao m
        // Colocar que o lugar preferencial é o início se for a primeira operação 
        dtjobMaqat = listaJobs(jobSel)
        tempos = dtjob(opSel,:)
        tempoNovaMQ = temposMaqs(mq) // tempo de Acordo com a listaCarregada do arquivo
        
        
        sair = 0 
        // Percorre toda a lista de espaços livres para definir se é viável ou não viável 
        [linesLibre,colLibres] = size(libres)
        for j=1:linesLibre
            tmpInicioLivreNext = libres(j,1)
            tmpInicioFimNext  = libres(j,2)
            tmpLivreTot =  libres(j,3)

            // Tempo requerido para executar nesta nova áquina
//                tmpLastTot = tmLastFim -tmLastInit // Tempo da última operação baseando-se no Job Atual 
            gap = tmpLivreTot - tempoAtual
//              
            // O início do espaço fazio deve ser maior ou maior que o da última atividade  OU (se a operação é 1ª é admitivo a inicialização antes da atual)
            // É permitido que seja inserido em uma nova posição quando o espaço 
            if (tmpInicioLivreNext >= tmLastFim | (opSel == 1 &  tmLastInit >= tmpInicioLivreNext)) then
                
                if (bestOrWorst == 1 &  gap <= gapBetter  ) then //beest
                   newMaq = mq
                   gapBetter = gap // Sempre atualiza o gap da primeira vez e na próxima este deve ser melhor que o anterior para entrar aqui, o que assegura o melhot fit (encaixe)
                elseif bestOrWorst == 1 & gap >= gapBetter then 
                   newMaq = mq
                   gapBetter = gap
                end
                
                // FirstFIT
                if (bestOrWorst == 3) then 
                    newMaq = mq
                    gapBetter = gap
                    sair = 1
                    break
                end
            end
            
        end
        
        // O FirstFIT vai no primeiro que encontrar
        if (bestOrWorst == 3 & sair == 1) then 
            break
        end
        
            
        
    end
    
    // Somente é considerado se o algoritmo conseguiu definir uma nova Máquina para ser adicionado ao conjunto solução 
    if newMaq ~= maquina then
        encontrei = 1
        listaExecucaoN = change_machine(listaExc, jobSel, opSel, newMaq)
//printf("Ok jb %d op %d mq %d\n ", jobSel, opSel, newMaq)
        [fitnessNew, dataprintseqBestPlace] = calcfitness(listaExecucaoN)
        
        
        if fitnessNew <= fitnessBestPlace then 
            listaOtimizada = listaExecucao
        else // Não atualiza nada se não for detectado nenhuma melhora
            listaExecucao = listaExc
            listaOtimizada = listaExc
            dataprintseqBestPlace = dataPrintFirstplace
            tipo='0'
            fitnessNew = fitnessBestPlace
        end
        
        
    else
        // Colocar os parâmetros default
        encontrei = 0
    end

endfunction

function [listaOtimizada, dataprintseqBestPlace, tipo, fitnessNew]=melhoraPrimeiro(listaExc) 
    [fitnessBestPlace, dataprintseqBestPlace] = calcfitness(listaExc)
    fitnessNew = fitnessBestPlace
    livres = getFree(dataprintseqBestPlace)
    sair=0

//        printf("OPT to init!!!\n")
    // Tenta jogar todas as primeiras atividades para o início    
    // Step 1 - Procura por n operações que não estão sendo executadas no início 
    notOnInit = find(dataprintseqBestPlace(:,4)~=0 & dataprintseqBestPlace(:,3)==1)
    
    if length(notOnInit) == 0 then 
        bestOrWorst = 1
    end

    for nI=1:length(notOnInit)
        linhaNi = notOnInit(nI)
        
        jobNoInit = dataprintseqBestPlace(linhaNi,2)
        opNotInit = 1
        maqNotInit = dataprintseqBestPlace(linhaNi,1) 

     
        [ tmLastInitNinit, tmLastFimNinit ]=  getTime (dataprintseqBestPlace, jobNoInit, opNotInit)
        totTfNotInit = tmLastFimNinit - tmLastInitNinit
        
        // Se tiver ao menos 0% de espaço no iníco, então testa-se 
        // Considera-se isso, pois se for colocado no 
        // Abordagem try to Fit -- mesmo se não tiver espaço suficiente no início 
        
        // Máquinas que podem fazer uma dada operação que seja diferente de maqNotInit 
        [ maqsNotInit ]= getMaqs(jobNoInit, opNotInit, maqNotInit)
        
        for mqI=1:length(maqsNotInit)
            mqNi = maqsNotInit(mqI,1)
            tmMqNi = maqsNotInit(mqI,2) 
            
            
            // Verifica na listagem quem ao menos 70% no início 
            for mqL=1:length(livres)
                cinqPercent = tmMqNi*0.7 // 70% do tempo 
                
                libreTimes = livres(mqL)
//                    temDisp = find(libreTimes)
                hasHere = find(libreTimes(:,1)>=0 & libreTimes(:,1) <=tmLastInitNinit & libreTimes(:,3) >=cinqPercent)
                
                // Se a máquina atende as restrições impostas
                if length(hasHere) ~= 0 then 
                    idL = hasHere(1)
                    newMaq = mqL
                    sair=1
                end // end achou
            end // end maqlivres
            
            if sair==1 then 
                break
            end
             
        end // Fim das máquinas que não tem a inicialização da primeira operação no início

        if sair==1 then 
            break
        end
    end
    
    
    
        
    if fitnessNew <= fitnessBestPlace then 
        listaOtimizada = listaExecucao
        if fitnessNew < fitnessBestPlace then 
            printf("Melhorei com o primeiro!!!\n")
        end
        
    else // Não atualiza nada se não for detectado nenhuma melhora
        
        listaExecucao = listaExc
        listaOtimizada = listaExc
        dataprintseqBestPlace = dataPrintFirstplace
        tipo='0'
        fitnessNew = fitnessBestPlace
    end
endfunction


// [listaOtimizada, dataprintseqBestPlace]=findFitMachine(listaExecucao, 1, 2)
// Maneira de se utilizar: 
// livres = getFree (lastToPrintBetter)



// Gera as fontes iniciais de alimento em Foods e a sequência de execução dos Jobs
//[FoodsSeqJob, Foods]= gen_Foods(maxCycle)

listexec = list()
FoodsSeqJob = list()

[listseqjb, listexec2] = getFromTempera (maxCycle*2) // Retorna
         
//printf("Lenght: %d\n", length(listseqjb))
//printf("Lenght: %d\n", length(listexec2))

[fitnesvetT, printseql]=list_fitess(listseqjb, listexec2)
 
for tdAd=1:maxCycle
     GlobalMinT = min(fitnesvetT)
     indexfitT = find(fitnesvetT==GlobalMinT)
     indexfitT = indexfitT(1)
     fdadd = listexec2(indexfitT)
     fitnesvetT(indexfitT) = 1000000
     listexec($+1) =  listexec2(indexfitT)
     FoodsSeqJob($+1) = listseqjb(indexfitT)
end
Foods = listexec

fitnesvet = list()
printseql = list()
BestFitness = 1000000000
[fitnesvet, printseql]=list_fitess(FoodsSeqJob, Foods)

tasks = []


bestfood = list()
indexfit = 1


// Se Passar 20 vezes e não se encontrou nenhuma solução nova 
// Gera-se mais 20 novas soluções
contadormelhora = 0
lastbetter = 10000000 // O melhor dos resultados o último 

// Lista de intervalos livres o que torna viável para 
// a implementação do WorstFit e BestFit
listaLivres = list()




 // executa o ABC
for r=1:runtime
     nTask=[]
     // Fitness das comidas 
      // reinicia os contadores trial( de julgamento)
     trial=zeros(1,maxCycle)
      
     BestInd = find(fitnesvet==min(fitnesvet))
     BestInd = BestInd(1)
     BestFood = Foods(BestInd)
     BestFitness = max(fitnesvet)
     lastToPrintBetter = printseql(BestInd)
     iter = 1

     // Tempo usado de cada máquina
     TmpByMaq = zeros(1,num_maq)
     TmpByMaqVazioInit = zeros(1,num_maq)
     
     canOpAll = ceil(rand()*num_maq)
     
      // Fase da abelha empregada 
      while (( iter <=maxCycle ))
          listaExecucaoAt = list()
          listaExecucao = list()
          
          // matriz referente a a abelha i
          listaExecucaoAt = Foods(iter) // Atual que vai para a final
          listaExecucao = listaExecucaoAt // Temporária
      
          seqjob = FoodsSeqJob(iter) // sequência dos jobs 
          matrizseq = printseql(iter) // matriz com toda a programação de job e operações
          fitnessI = fitnesvet(iter)
          
          maior = 0
          for contador=1:num_jobs
             nTask = [] // inicializa com 0 itens 
//             printf("Iter : %d\n", iter)
             [fitnessOld, dataprintseq] = calcfitness2(listaExecucaoAt, seqjob)
             jobsel = ceil(rand()*length(seqjob)) // selecionav um index
             jobsel = seqjob(jobsel)
          
             
             // Quantidade de operações do Job
             quantOp = op_jobs(jobsel)
             quantMaq = num_maq
             opsel = ceil(rand()*quantOp)
            
             qualApproach = ceil(rand()*3)
             
             if qualApproach == 1 then 
                // Abordagem FirstFIT, BestFit  e FirstFit
                [listaExecucao, dataprintseqNew, tipo, fitnessNew]=findFitMachine(listaExecucaoAt, jobsel, opsel)
             else
                // Abordagem puramente randômica 
                 novamaquina = getnumrand(num_maq, jobsel, opsel)
                 
                 // Nova Solução
                 listaExecucao = change_machine(listaExecucaoAt, jobsel, opsel, novamaquina)
                 [fitnessNew, dataprintseqNew] = calcfitness(listaExecucao)
             end
             
             
             
             // Recalcula o fitness para avaliar se melhorou ou não
             
             // verifica se houve melhora no tempo total do Job
             result = verifica(dataprintseq, dataprintseqNew, jobsel) // 1 -- melhorou e 0 -- não melhorou

             // Avaliação da nova solução
             fitness = 0
             
              res1 = (dataprintseq == dataprintseqNew)
             fres = find(res1==%T) // Procura para verificar há algum valor true 
             if length(fres) ~= 0 & fitnessNew <= fitnessOld 
//             if fitnessNew < fitnessOld 
                
                 
                listaExecucaoAt = listaExecucao
                Foods(iter) = listaExecucao
                
                trial(iter)=0;
//                printf("Fitness novo: %d\n", fitnessNew)
                fitness = fitnessNew
                dataprintseq = dataprintseqNew
            elseif fitnessNew == fitnessOld & result == 1 // Melhorou 
                listaExecucaoAt = listaExecucao
                Foods(iter) = listaExecucao
                trial(iter)=0;
//                printf("Fitness novo: %d\n", fitnessNew)
                fitness = fitnessNew
                dataprintseq = dataprintseqNew
            else
                listaExecucao = listaExecucaoAt
                trial(iter)=trial(iter)+1; // Se a solução não pode ser melhorada, incrementar +1 ao seu contador de julgamento (trial)
//                printf("Fitness old: %d\n", fitnessOld)
                fitness = fitnessOld
            end
            
            // Modifica a versão final melhor  no bestFIT
            // Atualiza os tempos de utilização de cada máquina
//             res1 = (lastToPrintBetter == dataprintseq)
//             fres = find(res1==%T)  //Procura para verificar há algum valor true 
//             if length(fres) ~= 0 & fitness <= BestFitness 
            if fitness < BestFitness then
                // Atualiza os globais usados em quase todo o código.
                 BestInd = iter
                 BestFood = Foods(iter)
                 BestFitness = fitness
                 listaExecucao = BestFood
                 lastToPrintBetter = dataprintseq
                
                 // Inicia o teste das máquinas
                 for mq=1:num_maq
                        soma = TmpByMaq(mq)
            
                        // percorre a lista lastToPrintBetter para montar os tempos de cada máquina
                        [lbetter, cbetter] = size(lastToPrintBetter)
                        for lb=1:lbetter
                            // maq job op inicio tim ---- lastToPrintBetter
                            if mq == lastToPrintBetter(lb,1) then
                                fim=5
                                inicio=4
                                // tempoAcumulado + tempousado para uma determinada operação de um JOB
                                soma = soma + (lastToPrintBetter(lb,fim)-lastToPrintBetter(lb,inicio))
                                // Tempo inicial, o que identifica tb a máquina 
                                if TmpByMaqVazioInit(mq) ~= 0 then
                                   TmpByMaqVazioInit(mq)  = lastToPrintBetter(lb,inicio))
                                end // teste ~=0
                            end // teste maq 
                        end // fim lista
                        TmpByMaq(mq) = soma
                  end // Fim teste máquinas
            //         end
                     
                     // Procura uma Atividade que pode ser otimizada
                     // Considera-se que uma atividade pode ser otimizada quando o tempo total é grande. Daí, busca-se a partir do início mover uma operação para outra máquina
                     // Desde que a máquina tenha o menor tempo
                     menortempo = min(TmpByMaq)
                     menorTempoInd = find(TmpByMaq==menortempo) // máquina com menor tempo
                     
                     // IdsWorstFind
                     idsWorst = []
                     piores = gsort(TmpByMaq)
                     piores2 = piores(1:2)
                     // Procura os IDS dos dois piores de toda a configuração dos tempos do Melhor 
                     // Tentaremos mexer nisso
                     for pio=1:length(piores2)
                         fndpio  = find(TmpByMaq==piores2(pio))
                         for pioid=1:length(fndpio)
                            // verifica se já tem na lista -- pode acontecer isso se houver 2 ou mais ids iguais --- evita duplicidade 
                            tem = find(idsWorst==fndpio(pioid))
                            
                            if length(tem) == 0 then
                                idsWorst($+1) = fndpio(pioid)
                            end
                         end
                     end // End idworst
                     
                     // PROCURA 2 melhores
                     idsBest = []
                     menores = gsort(TmpByMaq,'lc','i')
                     menores2 = menores(1:2) // os 2 primeiros que podem ser considerados
                     for mio=1:length(menores2)
                         fndmio  = find(TmpByMaq==menores2(mio))
                         for mioid=1:length(fndmio)
                            // verifica se já tem na lista -- pode acontecer isso se houver 2 ou mais ids iguais --- evita duplicidade 
                            tem = find(idsBest==fndmio(mioid))
                            if length(tem) == 0 then
                                idsBest($+1) = fndmio(mioid)
                            end
                         end
                     end // idbest
                     
                     // O trabalho deve ser sempre direcionado a melhor fonte de alimentos
                     listaExecucao = Foods(BestInd)
                     // Tenta melhorar a bagaça
                     for idw=1:length(idsWorst)
                        idMaq =  idsWorst(idw)
                        // Carrega as atividades da bagaça de acordo com a lista de execução 
                        ativsMaq = list() // vou adicionar um vetor com  job, operacao
                        for itInd=1:length(listaExecucao) // itInd=job
                            dataj = BestFood(itInd) // Datajob com as máquinas
                            for djind=1:length(dataj) // djind=operacao do job
                                if dataj(djind) == idMaq then
                                    ativsMaq($+1) = [ itInd djind ] // Adiciona job e operação
                                end
                            end
                        end // fim carrega atividades de uma máquina que tem muito tempo
                        
                        // Step 1 - verifica na lista principal se há disponibilidade nas máquinas ociosas, ou seja, quando o valor é diferente de zero (qualquer valor é admitido)
                        // Step 2 - Adiciona na listadeexecucao e recalcula o fitness
                        // Step 3 - Se não foi piorado o resultado global, considera-se o novo resultado
                        for idativs=1:length(ativsMaq)
                            
                            // to REPLACE
                            dtjobMaq = ativsMaq(idativs) // pega o job e a operação que executa na máquina
                             // listaJobs inicialmente carregados do arquivo txt
                            jobReplace = dtjobMaq(1)
                            opReplace =  dtjobMaq(2)
                            jobdt = listaJobs(jobReplace)
                            
                            for mioMaq=1:length(idsBest)
                                mqLessTime = idsBest(mioMaq)
                                tempo = jobdt(opReplace,mqLessTime)
                                
                                // Muda com o changeMachine 
                                if tempo ~= 0 then
                                    // Ok, podemos mudar 
                                    // Nova Solução
                                    
                                    if canOpAll == 1 then 
                                        [listaExecucaoAfter, dtseqNew, tipo, ftNew]=findFitMachine(listaExecucao, jobReplace, opReplace)
                                        
                                    else
                                        listaExecucaoAfter = change_machine(listaExecucao, jobReplace, opReplace, mqLessTime) // tem que definir para qual vai
                                        [ftNew, dtseqNew] = calcfitness(listaExecucaoAfter)
                                        
                                         // Tenta uma otimização baseado-se no espaço de execução entre uma operação e   outra 
//                                         [listaExecucaoAfter, dtseqNew] = otimizaWorst (listaExecucaoAfter)
                                        // se for melhor, podemos parar 
                                    end
                                    if ftNew <= BestFitness then  // Observar os critérios estipulados acima.
                                        // Atualiza 
                //                      BestInd = iter
                                        Foods(BestInd) = listaExecucaoAfter
                                        listaExecucao = listaExecucaoAfter
                                        BestFitness = ftNew
                                        lastToPrintBetter = dtseqNew
            //                            printf("\nCONSEGUI MELHORAR AQUI!\n\n");
                                    end // fim teste para testar 
                                end // Teste tempo -- quando for 0 a máquina não pode executar a atividade
                            end // fim iteração que testa a inserção de operações da maior nas menores
                        end // Fim tentativa de mudança da máquina para outra.
                     end// Fim melhor com mudança de máquina desde que seja possível encaixar-se abordagem ANY FIT less in use
                     
                     // Inicializa a lista de vazios
                     
                     
            end // Fim atualiza BestFitness, Foods(BestInd) e lastToPrintBetter

         end
         
         iter = iter + 1
        //          printf("iter: %d\n", iter)
      end // Fim empregadas
      
      
      try
        prob = (0.9*fitness/BestFitness)+0.1;
       catch
           prob = 1 // assim que são adicionados novos individuos(FOODs)
           printf("Prob alternativa \n")
       end
       
//      printf("Probabilidade: %f\n", prob)
      
      iter=1 
      t=1

      // Início Fase da abelha espectadora
//      printf("Abelha espectadora\n")
//      printf("Food :%d\n", FoodNumber)
      while(t < FoodNumber)
          if rand() <= prob 
//            printf("iter: %d\n", iter)
            listaExecucaoAt = list() // Atual que vai para a final
            listaExecucao = list() // Temporária
            // matriz referente a a abelha i
            listaExecucaoAt = Foods(iter) // Atual que vai para a final
            listaExecucao = Foods(iter) // Temporária
            seqjob = FoodsSeqJob(iter) // sequência dos jobs 
            matrizseq = printseql(iter) // matriz com toda a programação de job e operações
            fitnessI = fitnesvet(iter)

            maior = 0
            for contador=1:num_jobs
               [fitnessOld, dataprintseq] = calcfitness2(listaExecucaoAt, seqjob)
               // Selecionar o job 
               nTask = []
              jobsel = ceil(rand()*length(seqjob))
              jobsel = seqjob(jobsel)
             
              // Quantidade de operações do Job
              quantOp = op_jobs(jobsel)
              quantMaq = num_maq
              opsel = ceil(rand()*quantOp)
              novamaquina = getnumrand(num_maq, jobsel, opsel)
             
              // Atualizando na lista que contém a sequência de jobs, operações e máquinas 
              nTask = listaExecucao(jobsel)
              nTask(opsel) = novamaquina
//              printf("length: %d\n", length(mTask))
              
//              printf("2 - jobsel: %d\n", jobsel)

              listaExecucao(jobsel) = nTask
              mTask = nTask
              
              // Atualiza na lista de comidas
//            printf("Tamanho da lista antes calcfitness 2: %d\n", length(listaExecucao))
              
              [fitnessNew, dataprintseqNew] = calcfitness2(listaExecucao,seqjob)
//             printf("Continuando\n")
             
//              printf("Fitness old: %d\n", fitnessOld)
              // Avaliação da nova solução
              fitness = 0
              // verifica se houve melhora no tempo total do Job
              result = verifica(dataprintseq, dataprintseqNew, jobsel) // 1 -- melhorou e 0 -- não melhorou
              
                // Modifica a versão final melhor  no bestFIT
            // Atualiza os tempos de utilização de cada máquina
//             res1 = (dataprintseq == dataprintseqNew)
//             fres = find(res1==%T)  //Procura para verificar há algum valor true 
//             if length(fres) ~= 0 & fitnessNew <= fitnessOld 
              if fitnessNew < fitnessOld
                 listaExecucaoAt = listaExecucao
                 Foods(iter) = listaExecucao
                 FoodsSeqJob(iter) = seqjob
                 trial(iter)=0;
//                 printf("Fitness novo: %d\n", fitnessNew)
                 fitness = fitnessNew
                 dataprintseq = dataprintseqNew
            elseif fitnessNew == fitnessOld & result == 1 // & length(fres) ~= 0 // Melhorou 
                listaExecucaoAt = listaExecucao
                Foods(iter) = listaExecucao
                FoodsSeqJob(iter) = seqjob
                trial(iter)=0;
//                printf("Fitness novo: %d\n", fitnessNew)
                fitness = fitnessNew
                dataprintseq = dataprintseqNew
              else
                  // Mantém o resultado anterior
                 listaExecucao = listaExecucaoAt
                 trial(iter)=trial(iter)+1; // Se a solução não pode ser melhorada, incrementar +1 ao seu contador de julgamento (trial)

//                 printf("Fitness old: %d\n", fitnessOld)
                 fitness = fitnessOld
                 
              end
              
//             res1 = (dataprintseq == lastToPrintBetter)
//             fres = find(res1==%T) //Procura para verificar há algum valor true 
//             if length(fres) ~= 0 &  fitness <= BestFitness  then 
            if fitness <= BestFitness then
                // Atualiza os globais 
                BestInd = iter
                BestFood = Foods(iter)
                FoodsSeqJob(iter) = seqjob
                BestFitness = fitness
                lastToPrintBetter = dataprintseq
//                printf("Fitness new: %d\n", fitness)
//                printf("Atualiza better - espectadora!!! -- new %d\n", fitness)       
            end
          end

//          if (iter==(FoodNumber)+1) 
//            iter=1;
//          end;
          iter=iter+1;
          t = t + 1
      end

//      printf("index: %d\n", indexfit)
  end
  
//  abort
        
   // atualiza o fitness global para imprimir
  [fitnesvet, printseql]=list_fitess(FoodsSeqJob, Foods)
  GlobalMin = min(fitnesvet)
//      printf("Mingobal: %d\n", GlobalMin)
  indexfit = find(fitnesvet==GlobalMin)

  indexfit = indexfit(1)
  bestfood = Foods(indexfit)
//  printf("Abortei FIM\n")
       

  ind=find(trial==max(trial))
  hasdif = find(ind~=indexfit)

  if length(hasdif) == 0 then
     continue
  end
  
  indexr = ceil(rand()*length(hasdif))
  
  ind=hasdif(indexr)
  
  // gera nova fonte de alimento quando um determinado trial atinge um número algo 
  if trial(ind)>limit & indexfit ~= ind then
     trial(ind)=0;
     
     // Quando acontecer de haver 50 iterações sem a geração de uma solução melhor novos individuos são gerados
     if contadormelhora < 30 then
        [listseqjb, listexec]= gen_Foods(1)
         
         Foods(ind) = listexec(1)
         FoodsSeqJob(ind) = listseqjb(1)
//         printf("Gerando um novo individuo!!!\n")
         printf("contadormelhora %d\n", contadormelhora)
     else
//         numInd = ceil(rand()*30)
          numInd=30
//         printf("GERANDO %d NOVOS INDIVIDUOS!!!\n", numInd)
//         [listseqjb, listexec]= gen_Foods(39)//numInd) // Old Way
         [listseqjb, listexec2] = getFromTempera (60) // Retorna
         
         listexec = list()
         listsecT = list()
         [fitnesvetT, printseql]=list_fitess(listseqjb, listexec2)
         
         for tdAd=1:39
             GlobalMinT = min(fitnesvetT)
             indexfitT = find(fitnesvetT==GlobalMinT)
             indexfitT = indexfitT(1)
             fdadd = listexec2(indexfitT)
             fitnesvetT(indexfitT) = 1000000
             listexec($+1) =  listexec2(indexfitT)
             listsecT($+1) = listseqjb(indexfitT)
         end
         
         // Triais em ordem decrescente que tem piores fitnesses 
         jaremovidos = [] // guarda indexes que já foram removidos
         sortedtrial = gsort(fitnesvet)
         first20substituir = sortedtrial(1:numInd)
         for newInd=1:numInd
             toRem = first20substituir(1)
             first20substituir(1) = {}
             ondetem = find(fitnesvet==toRem)
             
             // Procura onde se pode remover os itens
             indexr=0
             for tR=1:length(ondetem)
                 tem = find(jaremovidos==ondetem(tR))
                 
                 if length(tem) == 0
                    indexr = ondetem(tR)
                    jaremovidos($+1) = indexr
                    Foods(indexr) = listexec(tR)
                    trial(indexr)=0; // zera o trial para que estas fontes sejam trabalhadas mais durante um tempo
                    FoodsSeqJob(indexr) = listsecT(tR)
//                    listexec(1) = {} // remove
                    printf("Adicionando %dº\n", newInd)
//                    printf("Len jaremovidos : %d\n", length(jaremovidos))
                    break
                 end
                 
             end
         end
         
         Foods(ind) = listexec(1)
         FoodsSeqJob(ind) = listsecT(1)
         
         contadormelhora = 0
     end
     
  elseif  indexfit == ind // zera caso o mellhor seja igual ao melhor fitness
     trial(ind)=0;
//     printf("Zera!!!\n")
  end

  
  // seleciona um aleatoriamente para ser excluído
  paraexcluir = ceil(rand()*length(Foods))
  
  Foods(BestInd) = BestFood // sempre mantém a melhor fonte de alimento
  listaExecucao =  BestFood
  [fitnessNew, lastToPrintBetter] = calcfitness2(listaExecucao, FoodsSeqJob(BestInd))
  BestFitness = fitnessNew
  
  
  // King Bee 
  // Analisa o Belhor em alguns momentos que 
  kingAnalisar = ceil(rand()*10)
  
  if kingAnalisar == 10 then
//      printf("QUEEN BEE\n")
    [listaExecucaoNew,lastToPrintBetter ] =  melhorarWorst(BestFood, lastToPrintBetter)
    [fitnessNew, lastToPrintBetter] = calcfitness(listaExecucaoNew)
//     [listaExecucaoNew, lastToPrintBetter, tipo, fitnessNew]=melhoraPrimeiro(listaExecucao) 
   
    if fitnessNew <= BestFitness then
         if fitnessNew < BestFitness then 
            printf("\n\nMelhorado pela rainha1!\n")
         end
         
         Foods(BestInd) = listaExecucao
         listaExecucao = listaExecucaoNew 
         BestFitness = fitnessNew
    end
    
    q = ceil(rand()*2)
    if q == 1 then 
        try
       [listaExecucaoNew, lastToPrintBetterN, tipo, fitnessNew]=melhoraPrimeiro(listaExecucao)
   catch
       printf("Erro!!! - não sei pq dá erro aqui.Desculpe-me não deu tempo de arrumar\n")
   end
   
    else
        
         [listaExecucaoNew, lastToPrintBetterN] = otimizaWorst (listaExecucaoNew)
         [fitnessNew, lastToPrintBetterN] = calcfitness(listaExecucaoNew)
            
    end
     
     
//       res1 = (lastToPrintBetterN == lastToPrintBetter)
//   fres = find(res1==%T)  Procura para verificar há algum valor true 
//    if length(fres) ~= 0 &  fitnessNew <= BestFitness  then 

    if fitnessNew <= BestFitness then
          if fitnessNew < BestFitness then 
            printf("Melhorado pela rainha2!\n")
         end
         
        
         Foods(BestInd) = listaExecucao
         listaExecucao = listaExecucaoNew 
         BestFitness = fitnessNew
         lastToPrintBetter = lastToPrintBetterN
    end
  end
  
//  lastToPrintBetter = printseql(BestInd)
//  Foods(paraexcluir) = BestFood
  printf("Best fitness %d no r=%d BestInd %d\n", BestFitness, r, BestInd)
  
  
  // Inicializa na primeira iteração do laço mais externo
  if r==1 then 
    lastbetter = BestFitness
  end
  
  if BestFitness == lastbetter then 
    contadormelhora = contadormelhora + 1
//    printf("Contador melhora: %d\n", contadormelhora)
  end
  
  if BestFitness < lastbetter then
      lastbetter = BestFitness
      contadormelhora = 0
  end
  
  
  hist = [hist BestFitness]
  histmin = [histmin min(hist)]
  
  rand('seed',getdate('s'))
 end

// COMANDO PARA GERAR O GRÁFICO DE GANTT --- pornografico
