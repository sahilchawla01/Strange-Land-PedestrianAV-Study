using System;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.InputSystem;

public class SC_StartupManager : MonoBehaviour
{
    private void Update()
    {
        if (Keyboard.current.hKey.wasPressedThisFrame)
        {
            StartHost();
        }
        
        if (Keyboard.current.cKey.wasPressedThisFrame)
        {
            StartClient();
        }
    }

    private void StartHost()
    {
        NetworkManager.Singleton.StartHost();
    }
    
    private void StartClient()
    {
        NetworkManager.Singleton.StartClient();
    }
}
