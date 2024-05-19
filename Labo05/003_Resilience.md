# Task 3 - Add and exercise resilience

By now you should have understood the general principle of configuring, running and accessing applications in Kubernetes. However, the above application has no support for resilience. If a container (resp. Pod) dies, it stops working. Next, we add some resilience to the application.

## Subtask 3.1 - Add Deployments

In this task you will create Deployments that will spawn Replica Sets as health-management components.

Converting a Pod to be managed by a Deployment is quite simple.

  * Have a look at an example of a Deployment described here: <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>

  * Create Deployment versions of your application configurations (e.g. `redis-deploy.yaml` instead of `redis-pod.yaml`) and modify/extend them to contain the required Deployment parameters.

  * Again, be careful with the YAML indentation!

  * Make sure to have always 2 instances of the API and Frontend running. 

  * Use only 1 instance for the Redis-Server. Why?

    > Because it is the only stateful object. Creating another one could lead to problems, especially if both have different datas.

  * Delete all application Pods (using `kubectl delete pod ...`) and replace them with deployment versions.

  * Verify that the application is still working and the Replica Sets are in place. (`kubectl get all`, `kubectl get pods`, `kubectl describe ...`)

## Subtask 3.2 - Verify the functionality of the Replica Sets

In this subtask you will intentionally kill (delete) Pods and verify that the application keeps working and the Replica Set is doing its task.

Hint: You can monitor the status of a resource by adding the `--watch` option to the `get` command. To watch a single resource:

```sh
$ kubectl get <resource-name> --watch
```

To watch all resources of a certain type, for example all Pods:

```sh
$ kubectl get pods --watch
```

You may also use `kubectl get all` repeatedly to see a list of all resources.  You should also verify if the application stays available by continuously reloading your browser window.

  * What happens if you delete a Frontend or API Pod? How long does it take for the system to react?
    > As soon as one of the pods from a `Deployment` starts getting deleted (not even waiting for it to be done), another pod starts getting created. The overall process of recreating a deleted pod took ~5s even though deleting the pod took a bit more time.
    
  * What happens when you delete the Redis Pod?

    > It does the same as the other pods but after restarting a new pod, all the previous data is lost and the app doesn't work until you restart the api pods (most likely because the api pods do not attempt to reconnect to the database after a failure, or every so often, not on miss).
    
  * How can you change the number of instances temporarily to 3? Hint: look for scaling in the deployment documentation

    > `kubectl scale deployment {deployment_name} --replicas=3`
    
  * What autoscaling features are available? Which metrics are used?

    > With `kubectl autoscale deployment/nginx-deployment --min=10 --max=15 --cpu-percent=80` (from the doc), we can autoscale the amount of instance running in our ReplicaSet providing a maximum and a minimum. The autoscaling will be based on the cpu utilization. Reading the `--help`, this command doesn't seem to allow other metrics and if no `--cpu-percent` is provided, it uses a `default policy` that is not disclosed (might be changeable else where). Another method would be to create an object with the same method as until now: creating a yaml file (and do `kubectl apply hpy.yaml`. File's content is under "Deliverables").

    
  * How can you update a component? (see "Updating a Deployment" in the deployment documentation)

    > Modify a file and then execute the command: `kubectl edit {component}`. We can see the current information concerning the `Deployment` and change them on the fly and the `Deployment` will do a rollout, scaling the old ReplicaSet to 0 instances and creating a new one with the new provided yaml config.

## Subtask 3.3 - Put autoscaling in place and load-test it

On the GKE cluster deploy autoscaling on the Frontend with a target CPU utilization of 30% and number of replicas between 1 and 4. 

Load-test using Vegeta (500 requests should be enough).

> The following commands will be used to stress-test our TODO app
>
>```zsh
>$ echo "GET http://{External IP}" > todo.list
>
>$ vegeta attack -duration=50s -rate=10 -targets=todo.list | tee results.bin | vegeta report
>
>$ cat results.bin | vegeta plot --title="TODO" > results.html
>```


> [!NOTE]
>
> - The autoscale may take a while to trigger.
>
> - If your autoscaling fails to get the cpu utilization metrics, run the following command
>
>   - ```sh
>     $ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
>     ```
>
>   - Then add the *resources* part in the *container part* in your `frontend-deploy` :
>
>   - ```yaml
>     spec:
>       containers:
>         - ...:
>           env:
>             - ...:
>           resources:
>             requests:
>               cpu: 10m
>     ```
>

## Deliverables

Document your observations in the lab report. Document any difficulties you faced and how you overcame them. Copy the object descriptions into the lab report.

> // [Stress test of 5 req/sec for 2min]: The autoscaler detects a higher use of CPU than before and updates its metric (20%/30%) until 70%/30%. After this update, it created the 4 frontend pods to be able to receive all the requests. After the stress test finished, 3 pods were deleted automatically to let only one running.

```````sh
// TODO object descriptions
```````
### redis-deploy.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
  labels:
    component: redis
    app: todo
spec:
  replicas: 1
  selector:
    matchLabels:
      component: redis
      app: todo
  template:
    metadata:
      labels:
        component: redis
        app: todo
    spec:
      containers:
      - name: redis
        image: redis
        ports:
        - containerPort: 6379
        args:
        - redis-server 
        - --requirepass ccp2 
        - --appendonly yes

```
### api-deploy.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
  labels:
    component: api
    app: todo
spec:
  replicas: 2
  selector:
    matchLabels:
      component: api
      app: todo
  template:
    metadata:
      labels:
        component: api
        app: todo
    spec:
      containers:
      - name: api
        image: icclabcna/ccp2-k8s-todo-api
        ports:
        - containerPort: 8081
        env:
        - name: REDIS_ENDPOINT
          value: redis-svc
        - name: REDIS_PWD
          value: ccp2

```

### frontend-deploy.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
  labels:
    component: frontend
    app: todo
spec:
  replicas: 2
  selector:
    matchLabels:
      component: frontend
      app: todo
  template:
    metadata:
      labels:
        component: frontend
        app: todo
    spec:
      containers:
      - name: frontend
        image: icclabcna/ccp2-k8s-todo-frontend
        ports:
        - containerPort: 8080
        env:
        - name: API_ENDPOINT_URL
          value: http://api-svc:8081
        resources:
          requests:
            cpu: 10m
```

### hpa.yaml
<p>A file written to create a "Horizontal Pod Autoscaler", to allow the infra to scale up and down the targeted objects.</p>

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: frontend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: frontend-deployment
  minReplicas: 1
  maxReplicas: 4
  targetCPUUtilizationPercentage: 30
```