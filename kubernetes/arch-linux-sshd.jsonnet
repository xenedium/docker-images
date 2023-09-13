local nodePort = std.extVar("NODEPORT");
local pubKeyUrl = std.extVar("PUBKEY_URL");
local password = std.extVar("PASSWORD");

local resources = [
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'sshserver',
      labels: {
        app: 'sshserver',
      },
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: 'sshserver',
        },
      },
      template: {
        metadata: {
          name: 'sshserver',
          labels: {
            app: 'sshserver',
          },
        },
        spec: {
          containers: [
            {
              name: 'sshserver',
              image: 'xenedium/arch-linux-sshd:latest',
              imagePullPolicy: 'Always',
              ports: [
                {
                  containerPort: 2222,
                },
              ],
              env: [
                (if pubKeyUrl != null then {name: 'PUBKEY_URL', value: pubKeyUrl} else {}),
                (if password != null then {name: 'PASSWORD', value: password} else {}),
              ],
            },
          ],
          restartPolicy: 'Always',
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'sshserver',
    },
    spec: {
      type: 'NodePort',
      selector: {
        app: 'sshserver',
      },
      ports: [
        {
          protocol: 'TCP',
          port: 2222,
          targetPort: 2222,
        } + (if nodePort != null then {nodePort: nodePort} else {}),
      ],
    },
  },
];

resources