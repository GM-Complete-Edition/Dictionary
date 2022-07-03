Unit DictionaryCollection;

(*
    Name    : Dictionary
    Version : 3.37
    Author  : Frank Hliva
    Country : EU
    Date    : 10/07/2004
    Language: Delphi 7
    License : Public domain
*)

Interface

Uses
  Classes, SysUtils;

Type
  TItemAttribute=(iaNone,iaPublic,iaHidden,iaReadOnly,iaConstant);

  TDictionarySort=(dsValue,dsKey,dsShuffle);

  TDictionaryFind=(dfKeys,dfValues);

  TDictionaryItem=Record
    Key:AnsiString;
    Value:Variant;
    Attribute:TItemAttribute;
  End;

  TDictionaryItems=Array Of TDictionaryItem;

  TDictionary=Class(TComponent)
    Private
      FKeyList:TStringList;
      FItems:TDictionaryItems;
      FCount:Integer;
      Function GetExists(Key:AnsiString):Boolean;
      Function GetValue(Key:AnsiString):Variant;
      Procedure SetValue(Key:AnsiString; Value:Variant);
      Function GetAttribute(Key:AnsiString):TItemAttribute;
      Procedure SetAttribute(Key:AnsiString; Value:TItemAttribute);
    Protected
      Procedure ShuffleStrings(Strings:TStrings); Dynamic;
      Function ReadItem(Stream:TStream; Var Item:TDictionaryItem):Boolean; Dynamic;
      Procedure WriteItem(Stream:TStream; Item:TDictionaryItem); Dynamic;
      Procedure SortByKeyList; Dynamic;
    Public
      Constructor Create(AOwner:TComponent=Nil); Override;
      Destructor Destroy; Override;
      Procedure Free;
      Procedure Clear; Dynamic;
      Function Delete(Key:AnsiString):Boolean;
      Function Rename(Key,NewKey:AnsiString):Boolean;
      Function Copy(Key,NewKey:AnsiString):Boolean;
      Procedure MoveUp(Key:AnsiString);
      Procedure MoveDown(Key:AnsiString);
      Procedure Add(Dictionary:TDictionary; Replace:Boolean=True);
      Function Find(Value:Variant; DictionaryFind:TDictionaryFind=dfKeys; IgnoreCase:Boolean=False):Variant;
      Procedure FindAll(Value:Variant; Dictionary:TDictionary; DictionaryFind:TDictionaryFind=dfKeys; IgnoreCase:Boolean=False);
      Procedure LoadFromStream(Stream:TStream);
      Procedure SaveToStream(Stream:TStream);
      Procedure LoadFromFile(FileName:AnsiString);
      Procedure SaveToFile(FileName:AnsiString);
      Procedure LoadFromStrings(Strings:TStrings);
      Procedure SaveToStrings(Strings:TStrings);
      Procedure LoadFromDictionary(Dictionary:TDictionary);
      Procedure SaveToDictionary(Dictionary:TDictionary);
      Procedure Sort(SortType:TDictionarySort=dsValue); Dynamic;
      Property Count:Integer Read FCount;
      Property KeyList:TStringList Read FKeyList;
      Property Value[Key:AnsiString]:Variant Read GetValue Write SetValue;
      Property Exists[Key:AnsiString]:Boolean Read GetExists;
      Property Attribute[Key:AnsiString]:TItemAttribute Read GetAttribute Write SetAttribute;
  End;

  Procedure Register;

Implementation

Procedure Register;
Begin
  RegisterComponents('System',[TDictionary]);
End;

Constructor TDictionary.Create;
Begin
  Inherited;
  FKeyList:=TStringList.Create;
  Clear;
End;

Destructor TDictionary.Destroy;
Begin
  Clear;
  FKeyList.Free;
  Inherited;
End;

Procedure TDictionary.Free;
Begin
  If Self<>Nil Then Destroy;
End;

Procedure TDictionary.Clear;
Begin
  SetLength(FItems,0);
  FCount:=0;
  FKeyList.Clear;
End;

Function TDictionary.GetValue(Key:AnsiString):Variant;
Var
  C:Cardinal;
Begin
  Result:=False;
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do
    If FItems[C].Key=Key Then
      Begin
        If FItems[C].Attribute<>iaHidden Then Result:=FItems[C].Value;
        Exit;
      End;
End;

Procedure TDictionary.SetValue(Key:AnsiString; Value:Variant);
Var
  C:Cardinal;
  Exist:Boolean;
Begin
  Exist:=False;
  If FCount<>0 Then
    For C:=0 To FCount-1 Do If FItems[C].Key=Key Then
      Begin
        Exist:=True;
        Break;
      End;  
  If Exist Then
    Begin
      If FItems[C].Attribute=iaPublic Then FItems[C].Value:=Value;
    End  
      Else
        Begin
          Inc(FCount);
          SetLength(FItems,FCount);
          KeyList.Add(Key);
          FItems[FCount-1].Key:=Key;
          FItems[FCount-1].Value:=Value;
          FItems[FCount-1].Attribute:=iaPublic;
        End;
End;

Function TDictionary.GetExists(Key:AnsiString):Boolean;
Var
  C:Cardinal;
Begin
  Result:=False;
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do
    Begin
      If FItems[C].Key=Key Then
        Begin
          If FItems[C].Attribute=iaHidden Then Exit;
          Result:=True;
          Exit;
        End;
    End;
End;

Function TDictionary.GetAttribute(Key:AnsiString):TItemAttribute;
Var
  C:Cardinal;
Begin
  Result:=iaNone;
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do
    If FItems[C].Key=Key Then
      Begin
        Result:=FItems[C].Attribute;
        Exit;
      End;
End;

Procedure TDictionary.SetAttribute(Key:AnsiString; Value:TItemAttribute);
Var
  C:Cardinal;
Begin
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do
    If FItems[C].Key=Key Then
      Begin
        If ((FItems[C].Attribute<>iaConstant) And (Value<>iaNone))
          Then FItems[C].Attribute:=Value;
        Break;
      End;
End;

Function TDictionary.ReadItem(Stream:TStream; Var Item:TDictionaryItem):Boolean;
Var
  B:Byte;
  C:Cardinal;
  V:Variant;

  Function ReadString(Len:Cardinal):Variant;
  Var
    C:Cardinal;
    CH:Char;
  Begin
    Result:='';
    For C:=1 To Len Do
      Begin
        If Stream.Read(CH,1)=0 Then Exit;
        Result:=Result+CH;
      End;
  End;

Begin
  Result:=False;
  If Stream.Read(C,SizeOf(C))=0 Then Exit;
  Item.Key:=ReadString(C);
  KeyList.Add(Item.Key);
  Stream.Read(C,SizeOf(C));
  Item.Value:=ReadString(C);
  Stream.Read(B,SizeOf(B));
  Item.Attribute:=TItemAttribute(B);
  Result:=True;
End;

Procedure TDictionary.LoadFromStream(Stream:TStream);
Begin
  Clear;
  FCount:=1;
  Repeat
    SetLength(FItems,FCount);
    If Not(ReadItem(Stream,FItems[FCount-1])) Then
      Begin
        Dec(FCount);
        SetLength(FItems,FCount);
        Exit;
      End;
    Inc(FCount);
  Until False;
End;

Procedure TDictionary.WriteItem(Stream:TStream; Item:TDictionaryItem);
Var
  B:Byte;
  C:Cardinal;
Begin
  C:=Length(Item.Key);
  Stream.Write(C,SizeOf(C));
  TStringStream(Stream).WriteString(Item.Key);
  C:=Length(Item.Value);
  Stream.Write(C,SizeOf(C));
  TStringStream(Stream).WriteString(Item.Value);
  B:=Byte(Item.Attribute);
  Stream.Write(B,1);
End;

Procedure TDictionary.SaveToStream(Stream:TStream);
Var
  C:Cardinal;
Begin
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do WriteItem(Stream,FItems[C]);
End;

Procedure TDictionary.LoadFromFile(FileName:String);
Var
  Stream:TStream;
Begin
  If Not(FileExists(FileName)) Then Exit;
  Try
    Stream:=TFileStream.Create(FileName,fmOpenRead Or fmShareDenyWrite);
    LoadFromStream(Stream);
  Finally
    Stream.Free;
  End;
End;

Procedure TDictionary.SaveToFile(FileName:String);
Var
  Stream:TStream;
Begin
  Stream:=TFileStream.Create(FileName,fmCreate Or fmShareExclusive);
  Try
    SaveToStream(Stream);
  Finally
    Stream.Free;
  End;
End;

Function TDictionary.Delete(Key:AnsiString):Boolean;
Var
  C:Cardinal;
Begin
  Result:=False;
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do
    If FItems[C].Key=Key Then
      Begin
        If FItems[C].Attribute<>iaPublic Then Exit;
        FKeyList.Delete(FKeyList.IndexOf(Key));
        Dec(FCount);
        FItems[C]:=FItems[FCount];
        SetLength(FItems,FCount);
        Result:=True;
        Exit;
      End;
End;

Function TDictionary.Rename(Key,NewKey:AnsiString):Boolean;
Var
  Value:Variant;
Begin
  Value:=GetValue(Key);
  If Not(Delete(Key)) Then Exit;
  SetValue(NewKey,Value);
End;

Function TDictionary.Copy(Key,NewKey:AnsiString):Boolean;
Var
  Value:Variant;
  Attr:TItemAttribute;
Begin
  If GetAttribute(Key)=iaHidden Then Exit;
  SetValue(NewKey,GetValue(Key));
End;

Procedure TDictionary.SortByKeyList;
Var
  Dictionary:TDictionary;
  C,Count:Cardinal;
Begin
  Dictionary:=TDictionary.Create;
  Try
    Count:=FCount-1;
    For C:=0 To Count Do
      Dictionary.SetValue(FKeyList[C],GetValue(FKeyList[C]));
  Finally
    LoadFromDictionary(Dictionary);
    Dictionary.Free;
  End;
End;

Procedure TDictionary.MoveUp(Key:AnsiString);
Var
  ActualIndex:Integer;
Begin
  ActualIndex:=FKeyList.IndexOf(Key);
  If (ActualIndex-1)>=0 Then FKeyList.Move(ActualIndex,ActualIndex-1);
  SortByKeyList;
End;

Procedure TDictionary.MoveDown(Key:AnsiString);
Var
  ActualIndex:Integer;
Begin
  ActualIndex:=FKeyList.IndexOf(Key);
  If (ActualIndex+1)<FKeyList.Count Then FKeyList.Move(ActualIndex,ActualIndex+1);
  SortByKeyList;
End;

Procedure TDictionary.Add(Dictionary:TDictionary; Replace:Boolean);
Var
  C,Count:Cardinal;
Begin
  If Dictionary.FCount=0 Then Exit;
  KeyList.AddStrings(Dictionary.KeyList);
  Count:=Dictionary.FCount-1;
  For C:=0 To Count Do
    If Replace Or Not(GetExists(Dictionary.KeyList[C])) Then
      SetValue(Dictionary.KeyList[C],Dictionary.GetValue(Dictionary.KeyList[C]));
End;

Function TDictionary.Find(Value:Variant; DictionaryFind:TDictionaryFind; IgnoreCase:Boolean):Variant;
Var
  C,Count:Cardinal;
  V:Variant;
Begin
  Result:=False;
  If FCount=0 Then Exit;
  Count:=FCount-1;
  For C:=0 To Count Do
    Begin
      Case DictionaryFind Of
        dfKeys: V:=FItems[C].Key;
        dfValues: V:=FItems[C].Value;
      End;
      If IgnoreCase Then
        Begin
          V:=AnsiLowerCase(V);
          Value:=AnsiLowerCase(Value);
        End;
      If Pos(Value,V)<>0 Then
        Begin
          Result:=FItems[C].Key;
          Exit;
        End;
    End;
End;

Procedure TDictionary.FindAll(Value:Variant; Dictionary:TDictionary; DictionaryFind:TDictionaryFind=dfKeys; IgnoreCase:Boolean=False);
Var
  C,Count:Cardinal;
  V:Variant;
Begin
  If FCount=0 Then Exit;
  Count:=FCount-1;
  For C:=0 To Count Do
    Begin
      Case DictionaryFind Of
        dfKeys: V:=FItems[C].Key;
        dfValues: V:=FItems[C].Value;
      End;
      If IgnoreCase Then
        Begin
          V:=AnsiLowerCase(V);
          Value:=AnsiLowerCase(Value);
        End;
      If Pos(Value,V)<>0 Then
        Begin
          Dictionary.SetValue(FItems[C].Key,FItems[C].Value);
          Dictionary.SetAttribute(FItems[C].Key,FItems[C].Attribute);
        End;
    End;
End;

Procedure TDictionary.SaveToDictionary(Dictionary:TDictionary);
Begin
  Dictionary.FKeyList.Assign(KeyList);
  Dictionary.FItems:=System.Copy(FItems);
  Dictionary.FCount:=FCount;
End;

Procedure TDictionary.LoadFromDictionary(Dictionary:TDictionary);
Begin
  KeyList.Assign(Dictionary.FKeyList);
  FItems:=System.Copy(Dictionary.FItems);
  FCount:=Dictionary.FCount;
End;

Procedure TDictionary.SaveToStrings(Strings:TStrings);
Var
  C:Cardinal;
Begin
  If FCount=0 Then Exit;
  For C:=0 To FCount-1 Do
    Begin
      Strings.Add(FItems[C].Key);
      Strings.Add(FItems[C].Value);
    End;
End;

Procedure TDictionary.LoadFromStrings(Strings:TStrings);
Var
  C,N,Count:Cardinal;
  Key:Boolean;
Begin
  Count:=Strings.Count;
  If Count=0 Then Exit;
  Key:=True;
  Clear;
  SetLength(FItems,Count);
  Dec(Count);N:=0;
  For C:=0 To Count Do
    Begin
      If Key Then
        Begin
          FKeyList.Add(Strings[C]);
          FItems[N].Key:=Strings[C];
        End
          Else
            Begin
              FItems[N].Value:=Strings[C];
              FItems[N].Attribute:=iaPublic;
              Inc(N);
            End;
      Key:=Not(Key);
    End;
  FCount:=N;
End;

Procedure TDictionary.ShuffleStrings(Strings:TStrings);
Var
  S:TStringList;
  Line:Cardinal;
  C:Cardinal;
Begin
  Randomize;
  S:=TStringList.Create;
  Line:=0;
  Repeat
    C:=Random(Strings.Count);
    S.Add(Strings[C]);
    Strings.Delete(C);
    If Strings.Count=0 Then Break;
  Until False;
  Strings.Clear;
  Strings.AddStrings(S);
  S.Free;
End;

Procedure TDictionary.Sort(SortType:TDictionarySort);
Var
  Strings:TStringList;
  Dictionary:TDictionary;

  Procedure SortByValue;
  Var
    C,N:Cardinal;
  Begin
    For C:=0 To FCount-1 Do Strings.Add(FItems[C].Value);
    Strings.Sort;
    For C:=0 To FCount-1 Do
      For N:=0 To FCount-1 Do
        If FItems[N].Value=Strings[C] Then
          Begin
            Dictionary.SetValue(FItems[N].Key,FItems[N].Value);
            Dictionary.SetAttribute(FItems[N].Key,FItems[N].Attribute);
          End;
  End;

  Procedure SortByKey(Shuffle:Boolean);
  Var
    C,N:Cardinal;
  Begin
    Strings.Assign(FKeyList);
    If Shuffle Then ShuffleStrings(Strings)
      Else Strings.Sort;
    For C:=0 To FCount-1 Do
      For N:=0 To FCount-1 Do
        If FItems[N].Key=Strings[C] Then
          Begin
            Dictionary.SetValue(FItems[N].Key,FItems[N].Value);
            Dictionary.SetAttribute(FItems[N].Key,FItems[N].Attribute);
          End;
  End;

Begin
  If Count=0 Then Exit;
  Strings:=TStringList.Create;
  Dictionary:=TDictionary.Create;
  Try
    Case SortType Of
      dsValue: SortByValue;
      dsKey: SortByKey(False);
      dsShuffle: SortByKey(True);
    End;
    LoadFromDictionary(Dictionary);
  Finally
    Strings.Free;
    Dictionary.Free;
  End;
End;

End.
