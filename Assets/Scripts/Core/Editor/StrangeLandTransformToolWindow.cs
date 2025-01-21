using UnityEditor;
using System.Collections.Generic;
using Unity.Netcode.Components;
using UnityEngine;

public class StrangeLandTransformToolWindow : EditorWindow
{
    [SerializeField]
    private List<GameObject> _prefabsToConfigure = new List<GameObject>();

    private SerializedObject _serializedObject;
    private SerializedProperty _prefabsProperty;

    /*
    the rationale of not having SyncTransform here is 
    1. the setting is saved in memory and is not presistent
    2. different children might want different settings
    (actually in this way we might need a bool AffectedByTool)
    */
    
    private class PrefabInfo
    {
        public GameObject PrefabRoot;
        public NetworkTransformType CurrentType;
    }

    private readonly List<PrefabInfo> _prefabInfos = new List<PrefabInfo>();

    [MenuItem("Tools/StrangeLandTransformTool")]
    public static void OpenWindow()
    {
        GetWindow<StrangeLandTransformToolWindow>("StrangeLand Transform Tool");
    }

    private void OnEnable()
    {
        _serializedObject = new SerializedObject(this);
        _prefabsProperty = _serializedObject.FindProperty("_prefabsToConfigure");
    }

    private void OnGUI()
    {
        EditorGUILayout.LabelField("StrangeLand Transform Tool", EditorStyles.boldLabel);
        EditorGUILayout.Space();

        _serializedObject.Update();
        EditorGUILayout.PropertyField(_prefabsProperty, new GUIContent("Prefabs to Configure"), true);
        _serializedObject.ApplyModifiedProperties();

        EditorGUILayout.Space();
        if (GUILayout.Button("Refresh Prefabs"))
        {
            RebuildPrefabInfos();
            
            foreach (var prefabInfo in _prefabInfos)
            {
                if (prefabInfo.CurrentType != NetworkTransformType.None)
                {
                    ApplySettingsToPrefab(prefabInfo, prefabInfo.CurrentType);
                }
            }
        }

        EditorGUILayout.Space(10);

        if (_prefabInfos.Count == 0)
        {
            EditorGUILayout.LabelField("No valid prefab info. Add prefabs above and click 'Refresh Prefabs'.");
            return;
        }

        foreach (var prefabInfo in _prefabInfos)
        {
            if (prefabInfo.PrefabRoot == null) 
                continue;

            EditorGUILayout.LabelField(prefabInfo.PrefabRoot.name, EditorStyles.boldLabel);

            EditorGUI.BeginChangeCheck();
            var newType = (NetworkTransformType)EditorGUILayout.EnumPopup(
                "Network Transform Type",
                prefabInfo.CurrentType
            );
            if (EditorGUI.EndChangeCheck())
            {
                UpdatePrefab(prefabInfo, newType);
            }

            if (GUILayout.Button("Apply for children"))
            {
                ApplyForChildren(prefabInfo, newType);
            }

            EditorGUILayout.Space(5);
        }
    }
    
    private void RebuildPrefabInfos()
    {
        _prefabInfos.Clear();

        foreach (var prefabAsset in _prefabsToConfigure)
        {
            if (prefabAsset == null)
                continue;

            // make sure we only process prefabs
            if (PrefabUtility.GetPrefabAssetType(prefabAsset) == PrefabAssetType.NotAPrefab)
                continue;

            string path = AssetDatabase.GetAssetPath(prefabAsset);
            if (string.IsNullOrEmpty(path))
                continue;

            GameObject tempInstance = PrefabUtility.InstantiatePrefab(prefabAsset) as GameObject;
            if (tempInstance == null)
                continue;

            StrangeLandTransform[] slTransforms = tempInstance.GetComponentsInChildren<StrangeLandTransform>(true);
            if (slTransforms == null || slTransforms.Length == 0)
            {
                DestroyImmediate(tempInstance);
                continue;
            }

            bool hasNetworkTransform = false;
            bool hasClientNetworkTransform = false;

            foreach (var slt in slTransforms)
            {
                var clientTrans = slt.GetComponent<ClientNetworkTransform>();
                var netTrans = slt.GetComponent<NetworkTransform>();

                bool isClient = (clientTrans != null);
                bool isBaseNetwork = (netTrans != null && netTrans.GetType() == typeof(NetworkTransform));

                // we have to check clientnetworktransform first because it's a subclass of networktransform
                // maybe can explicitly force the type?
                if (isClient)
                {
                    hasClientNetworkTransform = true;
                }
                else if (isBaseNetwork)
                {
                    hasNetworkTransform = true;
                }
            }

            DestroyImmediate(tempInstance);

            NetworkTransformType currentType = NetworkTransformType.None;
            if (hasNetworkTransform)
                currentType = NetworkTransformType.NetworkTransform;
            else if (hasClientNetworkTransform)
                currentType = NetworkTransformType.ClientNetworkTransform;

            _prefabInfos.Add(new PrefabInfo
            {
                PrefabRoot = prefabAsset,
                CurrentType = currentType
            });
        }
    }
    
    private void UpdatePrefab(PrefabInfo prefabInfo, NetworkTransformType newType)
    {
        if (newType == prefabInfo.CurrentType)
            return;  

        prefabInfo.CurrentType = newType;
        ApplySettingsToPrefab(prefabInfo, newType);
    }
    
    private void ApplyForChildren(PrefabInfo prefabInfo, NetworkTransformType newType)
    {
        ApplySettingsToPrefab(prefabInfo, newType);
    }
    
    private void ApplySettingsToPrefab(PrefabInfo prefabInfo, NetworkTransformType newType)
    {
        string path = AssetDatabase.GetAssetPath(prefabInfo.PrefabRoot);
        if (string.IsNullOrEmpty(path))
            return;

        GameObject tempInstance = PrefabUtility.InstantiatePrefab(prefabInfo.PrefabRoot) as GameObject;
        if (tempInstance == null)
            return;

        bool hasChanges = false;

        StrangeLandTransform[] slTransforms = tempInstance.GetComponentsInChildren<StrangeLandTransform>(true);
        foreach (var slt in slTransforms)
        {
            NetworkTransform netTrans = slt.GetComponent<NetworkTransform>();
            ClientNetworkTransform clientTrans = slt.GetComponent<ClientNetworkTransform>();

            if (newType == NetworkTransformType.NetworkTransform && clientTrans != null)
            {
                DestroyImmediate(clientTrans, true);
                hasChanges = true;
            }
            else if (newType == NetworkTransformType.ClientNetworkTransform 
                     && netTrans != null && netTrans.GetType() == typeof(NetworkTransform))
            {
                DestroyImmediate(netTrans, true);
                hasChanges = true;
            }
            else if (newType == NetworkTransformType.None && netTrans != null)
            {
                DestroyImmediate(netTrans, true);
                hasChanges = true;
            }
            else if (newType == NetworkTransformType.None && clientTrans != null)
            {
                DestroyImmediate(clientTrans, true);
                hasChanges = true;
            }

            if (newType == NetworkTransformType.NetworkTransform)
            {
                if (!slt.GetComponent<NetworkTransform>())
                {
                    netTrans = slt.gameObject.AddComponent<NetworkTransform>();
                    hasChanges = true;
                }
            }
            else if (newType == NetworkTransformType.ClientNetworkTransform)
            {
                if (!slt.GetComponent<ClientNetworkTransform>())
                {
                    clientTrans = slt.gameObject.AddComponent<ClientNetworkTransform>();
                    hasChanges = true;
                }
            }

            if (slt.SyncTransforms)
            {
                if (newType == NetworkTransformType.NetworkTransform)
                {
                    var finalNetTrans = slt.GetComponent<NetworkTransform>();
                    if (finalNetTrans != null)
                    {
                        finalNetTrans.SyncPositionX = slt.LogPosition;
                        finalNetTrans.SyncPositionY = slt.LogPosition;
                        finalNetTrans.SyncPositionZ = slt.LogPosition;

                        finalNetTrans.SyncRotAngleX = slt.LogRotation;
                        finalNetTrans.SyncRotAngleY = slt.LogRotation;
                        finalNetTrans.SyncRotAngleZ = slt.LogRotation;

                        finalNetTrans.SyncScaleX = slt.LogScale;
                        finalNetTrans.SyncScaleY = slt.LogScale;
                        finalNetTrans.SyncScaleZ = slt.LogScale;
                        hasChanges = true;
                    }
                }
                else if (newType == NetworkTransformType.ClientNetworkTransform)
                {
                    var finalClientTrans = slt.GetComponent<ClientNetworkTransform>();
                    if (finalClientTrans != null)
                    {
                        finalClientTrans.SyncPositionX = slt.LogPosition;
                        finalClientTrans.SyncPositionY = slt.LogPosition;
                        finalClientTrans.SyncPositionZ = slt.LogPosition;

                        finalClientTrans.SyncRotAngleX = slt.LogRotation;
                        finalClientTrans.SyncRotAngleY = slt.LogRotation;
                        finalClientTrans.SyncRotAngleZ = slt.LogRotation;

                        finalClientTrans.SyncScaleX = slt.LogScale;
                        finalClientTrans.SyncScaleY = slt.LogScale;
                        finalClientTrans.SyncScaleZ = slt.LogScale;
                        hasChanges = true;
                    }
                }
            }
        }

        if (hasChanges)
        {
            PrefabUtility.SaveAsPrefabAssetAndConnect(tempInstance, path, InteractionMode.AutomatedAction);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            Debug.Log($"[StrangeLandTransformTool] Updated prefab: {prefabInfo.PrefabRoot.name}");
        }

        DestroyImmediate(tempInstance);
    }
}
