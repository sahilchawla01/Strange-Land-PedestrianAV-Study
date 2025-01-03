using UnityEngine;
using System.Collections.Generic;

public class InteractableObjectsSO : SingletonSO<InteractableObjectsSO>
{
    public List<InteractableObjectSO> InteractableObjects = new List<InteractableObjectSO>();
}

