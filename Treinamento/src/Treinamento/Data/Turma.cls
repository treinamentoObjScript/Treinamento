Class Treinamento.Data.Turma Extends (%Persistent, %XML.Adaptor)
{

// Property Instrutor As Treinamento.Data.Instrutor [ SqlColumnNumber = 2 ];

Property DataInicio As %Date [ SqlColumnNumber = 3 ];

Property Status As %String [ SqlColumnNumber = 4 ];

// Property Alunos As list Of Treinamento.Data.Aluno [ SqlColumnNumber = 5 ];

// Property Curso As Treinamento.Data.Curso [ SqlColumnNumber = 6 ];

ClassMethod VerificaStatus(curso As %String) As %String [ Language = objectscript ]
{
	
	Set pService = "VerificaStatus"
    Set pSistema = "Treinamento.Data.Turma" 
    set pStatusProcesso = "Processo realizado com sucesso!"
	set (statusTurma,idLog, statusCode) = ""
	
	
	Try
	{
		Set statusCode = "1"
		//Set logMensagemCriar = ##class(Treinamento.Data.LogMensagem).CriarEntrada(pService,pSistema)
        set idLog = logMensagemCriar.%Id()
		Set SQL  = "Select * from Treinamento_Data.Turma  where Curso->Nome =? '"_curso_"'"
	    set resultSet = ##Class(%ResultSet).%New()
	    Set status = resultSet.Prepare(SQL)
	    Set status = resultSet.Execute()
	     
        if resultSet.Next()
        {
	         set statusTurma = resultSet.Get("Status")
	        //Set idTurma = resultSet.Get("ID")
			//Set turma = ##class(Treinamento.Data.Turma).%OpenId(idTurma)
			//Set statusTurma = turma.Status
        }
    
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		set pStatusProcesso = "Erro ao executar o processo: "_errorMessage
		Set statusCode ="0"
		//Set logMensagemFim = ##class(Treinamento.Data.LogMensagem).Finalizar(idLog, pStatusProcesso, statusCode)
		Throw exception
		
		
	}
	//Set logMensagemFim = ##class(Treinamento.Data.LogMensagem).Finalizar(idLog, pStatusProcesso,statusCode)
	 return statusTurma
}

ClassMethod ImprimeTurma(curso As %String) [ Language = objectscript ]
{
    Set pService = "ImprimeTurma"
    Set pSistema = "Treinamento.Data.Turma" 
    set pStatusProcesso = "Processo realizado com sucesso!"
    set (statusTurma,idLog,statusCode) = ""
    
	Set vStatus = $System.Status.OK()
	Try
	{  
	  Set statusCode = "1"
    //  Set logMensagemCriar = ##class(Treinamento.Data.LogMensagem).CriarEntrada(pService,pSistema)
      set idLog = logMensagemCriar.%Id()
	  Set SQL  = "Select * from Treinamento_Data.Turma  where Curso->Nome = '"_curso_"'"
	  Set resultSet = ##class(%ResultSet).%New()
	  
	  Set vStatus = resultSet.Prepare(SQL)
	  If $SYSTEM.Status.IsError(vStatus)
	  {
		   Quit 
	  }
      Set status = resultSet.Execute()
       If $SYSTEM.Status.IsError(vStatus)
       {
	        Quit 
       }
       If resultSet.Next(){
	       Set IdTurma = resultSet.Get("ID")
	       Set dataInicio = result.Get("DataInicio")
	       Set status =      result.Get("Status")
	       Set turma = ##class(Treinamento.Data.Turma).%OpenId(IdTurma)	       
       }
       For x=1:1:turma.Alunos.Count()
       {
	       Set aluno = turma.Alunos.GetAt(x)
	       Write " Nome : "_aluno.Nome, " Matricula :"_aluno.Matricula, " Idade : "_aluno.Idade,!
	   }
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		set pStatusProcesso = "Erro ao executar o processo: "_errorMessage
		Set statusCode = "0"
		//Set logMensagemFim = ##class(Treinamento.Data.LogMensagem).Finalizar(idLog, pStatusProcesso,statusCode)
		Throw exception
        
		
	}
   // Set logMensagemFim = ##class(Treinamento.Data.LogMensagem).Finalizar(idLog, pStatusProcesso,statusCode)
    return
}

ClassMethod ConsultaLog(status As %Boolean) [ Language = objectscript ]
{
	Set status = $SYSTEM.Status.OK()
	Set count = 0
	Try
	{  // Prop que armazena a 
	   Set tSQL = "select * from Treinamento_Data.LogMensagem where "
	   Set tSQL = tSQL_" Status = " _status
	   Set resultSet = ##class(%ResultSet).%New()
	   
	   //Prepara a query para execução
	   Set vStatus = resultSet.Prepare(tSQL)
	   If $SYSTEM.Status.IsError(vStatus) Return vStatus
	   
       //Executa a query
        Set vStatus = resultSet.Execute()
	    If $SYSTEM.Status.IsError(vStatus) Return vStatus
	    
      //percorre a lista para printar o log enquanto existir dados
       While (resultSet.Next())
       {
	       Set count= count+1    
	       Set ID             = resultSet.Get("ID")
	       Set Sistema        = resultSet.Get("Sistema")
	       Set Servico        = resultSet.Get("Servico")
	       Set Inicio         = resultSet.Get("Inicio")
	       Set Fim            = resultSet.Get("Fim")
	       Set Status         = resultSet.Get("Status")
	       Set StatusProcesso = resultSet.Get("StatusProcesso")
	       
	       if (count <=1)
	       {
	         Write "ID: ", "Sistema:                ", "Servico:              ", "Inicio:       ", "Fim:       "  , "Status : ", "StatusProcesso:                    ",!
	       }
	         Write ID_" "_Sistema_" "_Servico_" "_Inicio_" "_Fim_" "_Status_" "_StatusProcesso,! 
	        
	       
	      
	       
	   }
       
	   
	}
	Catch(exception)
	{
		Set tSC = exception.AsStatus()
		Set errorMessage = $System.Status.GetErrorText(tSC)
		Throw exception
	}
	return
}

Storage Default
{
<Data name="TurmaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataInicio</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Treinamento.Data.TurmaD</DataLocation>
<DefaultData>TurmaDefaultData</DefaultData>
<IdLocation>^Treinamento.Data.TurmaD</IdLocation>
<IndexLocation>^Treinamento.Data.TurmaI</IndexLocation>
<StreamLocation>^Treinamento.Data.TurmaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
