using UnityEngine;
using System.Collections.Generic;
using UnityEngine.Serialization;


public class ClientDisplaysSO : SingletonSO<ClientDisplaysSO>
{
    public List<ClientDisplaySO> ClientDisplays = new List<ClientDisplaySO>();
}
