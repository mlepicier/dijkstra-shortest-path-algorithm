Attribute VB_Name = "Dijktra"

'**** Global Matrices ****'
Global Arc(24, 24) As Integer 'Binary Matrix with Arc(i,j) = 1 an arc exists between node i and node j'
Global Distance(24, 24) As Variant 'Distance(i,j) = distance from node i to node j' 'Symetric Matrix'
Global Temps(24, 24) As Variant 'Temps(i,j) = time travelled from node i to node j' 'Symetric Matrix'
Global DistancierD(24, 24) As Integer 'Full Distance Matrix'
Global DistancierT(24, 24) As Integer 'Full Time Matrix'
Global Pdist(24) As Integer 'Predecessor table (Distance base)'
Global Ptime(24) As Integer 'Predecessor table (Time base)'
Global m As Integer   'Number of arcs'
Global n As Integer   'Number of nodes (cities)'

Function Dijkstra_Distance(s As Integer)

Dim Labels(24) As Variant 'Labels table'
Dim F(24) As Integer 'F(i) = 1 if node i has been fixed'
Dim x As Integer
Dim LabelsMin As Variant
Dim Sum As Integer 'Sum to calculate the cost of the shortest path'

n = 25

For i = 0 To n - 1  'Labels initialisation to infinite but s-1 to 0'
  Labels(i) = 100000
  Pdist(i) = 0
  F(i) = 0
Next i
Labels(s - 1) = 0

For K = 0 To n - 1 'Fixing all labels
  LabelsMin = 1000000
  For j = 0 To n - 1     'Finding the minimum non-fixed label'
    If F(j) = 0 And Labels(j) < LabelsMin Then
      x = j
      LabelsMin = Labels(x)
    End If
  Next j
  F(x) = 1   'Classify the node x as fixed'
  For j = 0 To n - 1       'Finding all successors'
    If Arc(x, j) = 1 Then   'If an arc exists' 'If j x'
      If LabelsMin + Distance(x, j) < Labels(j) And F(j) = 0 Then   'If label of j can be improved and is not fixed (because oriented graph)'
        Labels(j) = LabelsMin + Distance(x, j) 'We improve'
        Pdist(j) = x
      End If
    End If
  Next j
Next K

For l = 1 To n
  DistancierD(s - 1, l - 1) = Labels(l - 1)
  DistancierD(l - 1, s - 1) = DistancierD(s - 1, l - 1)
Next l

End Function

Function Dijkstra_Temps(s As Integer)

Dim Labels(24) As Variant 'Labels table'
Dim F(24) As Integer 'F(i) = 1 if node i has been fixed'
Dim x As Integer
Dim LabelsMin As Variant
Dim Sum As Integer 'Sum to calculate the cost of the shortest path'

n = 25

For i = 0 To n - 1  'Labels initialisation to infinite but s-1 to 0'
  Labels(i) = 100000
  Ptime(i) = 0
  F(i) = 0
Next i
Labels(s - 1) = 0

For K = 0 To n - 2 'Fixing all labels
  LabelsMin = 1000000
  For j = 0 To n - 1       'Finding the minimum non-fixed label'
    If F(j) = 0 And Labels(j) < LabelsMin Then
      x = j
      LabelsMin = Labels(x)
    End If
  Next j
  F(x) = 1   'Classify the node x as fixed'
  For j = 0 To n - 1       'Finding all successors'
    If Arc(x, j) = 1 Then   'If an arc exists' 'If j x'
      If LabelsMin + Temps(x, j) < Labels(j) And F(j) = 0 Then  'If label of j can be improved and is not fixed (because oriented graph)'
        Labels(j) = LabelsMin + Temps(x, j) 'We improve'
        Ptime(j) = x
      End If
    End If
  Next j
Next K

For l = 1 To n
  DistancierT(s - 1, l - 1) = Labels(l - 1)
  DistancierT(l - 1, s - 1) = DistancierT(s - 1, l - 1)
Next l

End Function



Sub DISTANCIERS()

Dim s As Integer    'Number of the departing city'

'**** Collecting Data ****'

Dim Ville1 As String
Dim Ville2 As String
Dim Numero_Ville1 As Integer
Dim Numero_Ville2 As Integer

m = 46
n = 25

For K = 1 To m 'Collecting information on all arcs'
  Ville1 = Sheets(2).Cells(6 + K, 2) 'Grab city's name on sheet 2'
  Ville2 = Sheets(2).Cells(6 + K, 3)
  For l = 0 To n - 1   'Compare names for each city'
    If Sheets(1).Cells(7 + l, 2) = Ville1 Then 'Store city's numbers'
      Numero_Ville1 = l
    ElseIf Sheets(1).Cells(7 + l, 2) = Ville2 Then
      Numero_Ville2 = l
    End If
  Next l
  Arc(Numero_Ville1, Numero_Ville2) = 1 'The arc existe'
  Arc(Numero_Ville2, Numero_Ville1) = Arc(Numero_Ville1, Numero_Ville2)
  
  '**** Euclidiean distance computation ****'
  Distance(Numero_Ville1, Numero_Ville2) = 100 * Sqr((Sheets(1).Cells(7 + Numero_Ville2, 5) - Sheets(1).Cells(7 + Numero_Ville1, 5)) ^ 2 + (Sheets(1).Cells(7 + Numero_Ville2, 6) - Sheets(1).Cells(7 + Numero_Ville1, 6)) ^ 2)
  Distance(Numero_Ville2, Numero_Ville1) = Distance(Numero_Ville1, Numero_Ville2)
  Sheets(2).Cells(6 + K, 5) = Round(Distance(Numero_Ville1, Numero_Ville2), 0) 'Writing down the distance'
  If Sheets(2).Cells(6 + K, 4) = "NO" Then 'Label Highways'
    Temps(Numero_Ville1, Numero_Ville2) = 60 * (Distance(Numero_Ville1, Numero_Ville2) / 80)
    Temps(Numero_Ville2, Numero_Ville1) = Temps(Numero_Ville1, Numero_Ville2)
    Sheets(2).Cells(6 + K, 6) = Round(Temps(Numero_Ville1, Numero_Ville2), 0) 'Write down time'
  Else
    Temps(Numero_Ville1, Numero_Ville2) = 60 * (Distance(Numero_Ville1, Numero_Ville2) / 110)
    Temps(Numero_Ville2, Numero_Ville1) = Temps(Numero_Ville1, Numero_Ville2)
    Sheets(2).Cells(6 + K, 6) = Round(Temps(Numero_Ville1, Numero_Ville2), 0) 'Write down time'
  End If
Next K

'**** Programm ****'
'Calling the Dijkstra procedure'

For i = 1 To n
    s = i
    Call Dijkstra_Distance(s)
    Call Dijkstra_Temps(s)
  For j = 1 To n
  Sheets(2).Cells(6 + i, 9 + j) = DistancierD(i - 1, j - 1) 'Writing down matrices'
  Sheets(2).Cells(34 + i, 9 + j) = DistancierT(i - 1, j - 1)
  Sheets(2).Cells(62 + j, 9 + i) = Pdist(j - 1) + 1
  Sheets(2).Cells(90 + j, 9 + i) = Ptime(j - 1) + 1
  Next j
Next i

End Sub
