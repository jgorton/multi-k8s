docker build -t jaredgorton/multi-client:latest -t jaredgorton/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jaredgorton/multi-server:latest -t jaredgorton/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jaredgorton/multi-worker:latest -t jaredgorton/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jaredgorton/multi-client:latest
docker push jaredgorton/multi-server:latest
docker push jaredgorton/multi-worker:latest

docker push jaredgorton/multi-client:$SHA
docker push jaredgorton/multi-server:$SHA
docker push jaredgorton/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=jaredgorton/multi-server:$SHA
kubectl set image deployments/client-deployment client=jaredgorton/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jaredgorton/multi-worker:$SHA
