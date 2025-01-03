using System.Collections.Generic;
using System;

public enum ParticipantOrder {
    A,
    B,
    C,
    D,
    E,
    F,
    None
};

public enum Language {
    English, 
    Hebrew, 
    Chinese, 
    German
}

[Serializable]
public struct ClientOption
{
    public ParticipantOrder PO;
    public int ClientInterface;
    public int InteractableObject;
}

[Serializable]
public struct JoinParameters
{
    public ParticipantOrder PO;
    public Language Language;
}