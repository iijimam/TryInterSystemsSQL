Imports System.Data.Odbc

Module Program
    Sub Main(args As String())
        Console.WriteLine("***検索テスト***")

        Dim conn As OdbcConnection = New OdbcConnection("DSN=Test")

        Dim SelectSQL As String = "SELECT VisitDate,Symptom,Count(*) as VisitCountByDate
                            FROM Training.Visit
                            GROUP BY VisitDate
                            ORDER BY VisitDate Desc"
        Try
            conn.Open()
            Dim cmd As OdbcCommand = New OdbcCommand(SelectSQL, conn)
            Dim DataReader As OdbcDataReader = cmd.ExecuteReader()


            While DataReader.Read()
                Console.WriteLine("{0},{1},{2} ", DataReader("VisitDate"), DataReader("Symptom"), DataReader("VisitCountByDate"))
            End While
        Catch ex As Exception
            Console.WriteLine(ex.Message)
        End Try



    End Sub
End Module