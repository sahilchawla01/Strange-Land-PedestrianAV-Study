using Unity.Netcode;
using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class SC_SetRandomClientColor : NetworkBehaviour
{
    public override void OnNetworkSpawn()
    {
        base.OnNetworkSpawn();
        SetColorBasedOnOwner();
    }

    protected override void OnOwnershipChanged(ulong previous, ulong current)
    {
        SetColorBasedOnOwner();
    }

    void SetColorBasedOnOwner()
    {
        Random.InitState((int) OwnerClientId);
        GetComponent<Renderer>().material.color = Random.ColorHSV();
    }
}
