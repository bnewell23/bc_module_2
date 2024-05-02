Sub stocks():

    Dim i As Long ' row number
    Dim vol As LongLong ' ticker volume
    Dim vol_total As LongLong ' total ticker volume
    Dim ticker As String ' ticker name
    Dim k As Long ' row for totals and changes
    
    Dim ticker_close As Double
    Dim ticker_open As Double
    Dim price_change As Double
    Dim percent_change As Double
        
    Dim lastRow As Long
    lastRow = ActiveSheet.Cells(ActiveSheet.Rows.Count, 1).End(xlUp).Row

    vol_total = 0
    k = 2
    
    ' assign open for first ticker
    ticker_open = Cells(2, 3).Value

    For i = 2 To lastRow:
        vol = Cells(i, 7).Value
        ticker = Cells(i, 1).Value

        If (Cells(i + 1, 1).Value <> ticker) Then
            vol_total = vol_total + vol
            
            ' get the closing price of the ticker
            ticker_close = Cells(i, 6).Value
            price_change = ticker_close - ticker_open
            
            ' Calculate percent_change
            If (ticker_open > 0) Then
                percent_change = price_change / ticker_open
            Else
                percent_change = 0
            End If
            
            ' assign values to column K
            Cells(k, 9).Value = ticker
            Cells(k, 10).Value = price_change
            Cells(k, 11).Value = percent_change
            Cells(k, 12).Value = vol_total
            
            ' Conditional formatting for column J
            If (price_change > 0) Then
                Cells(k, 10).Interior.ColorIndex = 4
            ElseIf (price_change < 0) Then
                Cells(k, 10).Interior.ColorIndex = 3
            Else
                Cells(k, 10).Interior.ColorIndex = 2
            End If

            ' reset
            vol_total = 0
            k = k + 1
            ticker_open = Cells(i + 1, 3).Value
        Else
            vol_total = vol_total + vol
        End If
    Next i
    
    Cells(1, 9) = "Ticker Name"
    Cells(1, 10) = "Quarterly Change"
    Cells(1, 11) = "Percent Change"
    Cells(1, 12) = "Total Volume"
    Columns("K:K").NumberFormat = "0.00%"
End Sub

Sub Leaderboard():

    Dim ws As Worksheet
    Dim lastRow As Long
    Dim maxIncrease As Double
    Dim maxTicker As String
    Dim i As Long
    Dim maxDecrease As Double
    Dim maxDecreaseRow As Long
    Dim maxTotal As Double
    Dim maxVolumeTicker As String
    
    Set ws = ActiveSheet
    lastRow = ws.Cells(ws.Rows.Count, "K").End(xlUp).Row
    lastRow = ws.Cells(ws.Rows.Count, "L").End(xlUp).Row
    maxIncrease = 0
    maxDecrease = 0
    maxDecreaseRow = 0
    maxTotal = 0
    
    ' assisted with Xpert
    For i = 2 To lastRow
        ' Calculate maxIncrease.
        If ws.Cells(i, "K").Value > maxIncrease Then
            maxIncrease = ws.Cells(i, "K").Value
            maxTicker = ws.Cells(i, "I").Value
        End If
        
        ' Calculate maxDecrease
        If ws.Cells(i, "K").Value < maxDecrease Then
            maxDecrease = ws.Cells(i, "K").Value
            maxDecreaseRow = i
        End If
        
        If maxDecreaseRow > 0 Then
            ws.Cells(maxDecreaseRow, "I").Copy ws.Cells(3, "P") ' Copy ticker symbol to column P
            ws.Cells(maxDecreaseRow, "K").Copy ws.Cells(3, "Q") ' Copy percent change to column Q
        End If
        
        ' Calculate maxTotal
        If ws.Cells(i, "L").Value > maxTotal Then
            maxTotal = ws.Cells(i, "L").Value
            maxVolumeTicker = ws.Cells(i, "I").Value
        End If
        
    Next i
    
    ' Output the results to Columns P and Q
    ws.Range("O2").Value = "Greatest % Increase"
    ws.Range("O3").Value = "Greatest % Decrease"
    ws.Range("O4").Value = "Greatest Total Value"
    ws.Range("P2").Value = maxTicker
    ws.Range("Q2").Value = maxIncrease
    ws.Range("Q4").Value = maxTotal
    ws.Range("P4").Value = maxVolumeTicker
    Cells(4, 17).NumberFormat = "0"
    Cells(2, 17).NumberFormat = "0.00%"
    Cells(3, 17).NumberFormat = "0.00%"
End Sub
