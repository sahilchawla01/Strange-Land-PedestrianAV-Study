using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.Netcode;
using UnityEngine;


public abstract class InteractableObject : NetworkBehaviour {

    public NetworkVariable<ParticipantOrder> _participantOrder = new NetworkVariable<ParticipantOrder>();

    public ClientInterface MyClientInterface { get; set; }
    
    private void Awake()
    {
        instances.Add(this);
    }

    public override void OnDestroy() {
        instances.Remove(this);
    }
    
    private static List<InteractableObject> instances = new List<InteractableObject>(); // Can cause memory leakage if not kept clean...!!! 
    public static IReadOnlyList<InteractableObject> Instances => instances.AsReadOnly();
    
    public void SetParticipantOrder(ParticipantOrder _ParticipantOrder)
    {
        _participantOrder.Value = _ParticipantOrder;
    }
    public ParticipantOrder GetParticipantOrder()
    {
        return _participantOrder.Value;
    }
    
    public abstract void SetStartingPose(Pose _pose);
    public abstract void AssignClient(ulong CLID_, ParticipantOrder _participantOrder_);
    public abstract Transform GetCameraPositionObject();

    public abstract void Stop_Action();
    public abstract bool HasActionStopped();
}