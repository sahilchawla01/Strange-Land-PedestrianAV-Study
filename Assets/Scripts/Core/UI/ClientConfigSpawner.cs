using System.IO;
using UnityEngine;
using System.Linq;

/* My design thought is that, we don't need update the config file on every change,
So this script handles the spawning of elements and keeps a local reference,
And startup script simply asks this script to update the clientoptions when needed. 
*/

public class ClientConfigSpawner : MonoBehaviour
{
    public GameObject clientConfigPrefab;

    private const string FILE_NAME = "ClientOptions.json";
    private string FilePath => Application.persistentDataPath + "/" + FILE_NAME;
    
    private ClientConfigUI[] spawnedConfigUIs;

    public void SpawnConfigs()
    {
        if (File.Exists(FilePath))
        {
            string json = File.ReadAllText(FilePath);
            
            ClientOptions loadedInstance = JsonUtility.FromJson<ClientOptions>(json);
            if (loadedInstance != null && loadedInstance.Options.Count == 6)
            {
                ClientOptions.Instance = loadedInstance;
                Debug.Log("Loaded existing ClientOptions from disk.");
            }
            else
            {
                Debug.LogWarning("File found but had invalid data!");
            }
        }
        else
        {
            Debug.Log("No config file found. Using default ClientOptions.");
        }
        
        spawnedConfigUIs = new ClientConfigUI[6];

        for (int i = 0; i < 6; i++)
        {
            var option = ClientOptions.Instance.Options[i];

            var go = Instantiate(clientConfigPrefab, transform);
            var ui = go.GetComponent<ClientConfigUI>();
            spawnedConfigUIs[i] = ui;

            // ??? using color tag gives errors -- will investigate later
            // ui.POText.text = $"""Participant Order <color="blue">{option.PO}</color>""";
            ui.POText.text = $"Participant Order {option.PO}";
            
            var interfaceNames = ClientInterfacesSO.Instance.ClientInterfaces
                .Select(ci => ci.ID)
                .ToList();

            ui.ClientInterfaceDropdown.ClearOptions();
            ui.ClientInterfaceDropdown.AddOptions(interfaceNames);

            ui.ClientInterfaceDropdown.value = option.ClientInterface;
            ui.ClientInterfaceDropdown.RefreshShownValue();

            var objNames = InteractableObjectsSO.Instance.InteractableObjects
                .Select(io => io.ID)
                .ToList();

            ui.SpawnTypeDropdown.ClearOptions();
            ui.SpawnTypeDropdown.AddOptions(objNames);

            ui.SpawnTypeDropdown.value = option.InteractableObject;
            ui.SpawnTypeDropdown.RefreshShownValue();
            
        }
    }

    public void UpdateClientOptionsFromUI()
    {
        if (spawnedConfigUIs == null || spawnedConfigUIs.Length < 6) return;

        for (int i = 0; i < 6; i++)
        {
            var ui = spawnedConfigUIs[i];
            var option = ClientOptions.Instance.Options[i];
            option.ClientInterface = ui.ClientInterfaceDropdown.value;
            option.InteractableObject = ui.SpawnTypeDropdown.value;

            ClientOptions.Instance.Options[i] = option;
        }
    }
}
