package IA.CentralEnergia;

import IA.Energia.*;
import java.util.*;

public class CentralEnergiaEstado {
    static Centrales _centrales;
    static Clientes _clientes;

    static int _n_clientes;
    static int _n_centrales;

    static int totalCliGar;

    ArrayList<Integer> asigClientes;
    ArrayList<Double> consumoCentrales;

    public int getTotalCliGar() {
        return totalCliGar;
    }

    public CentralEnergiaEstado(int[] numCentralesTipo, int seedCentrales, int numClientes, double[] propClientes, double propGarantizados, int seedClientes) throws Exception {
        _centrales = new Centrales(numCentralesTipo, seedCentrales);
        _clientes = new Clientes(numClientes, propClientes, propGarantizados, seedClientes);

        _n_clientes = numClientes;
        _n_centrales = numCentralesTipo[0] + numCentralesTipo[1] + numCentralesTipo[2];
        totalCliGar = (int)(propGarantizados * numClientes);

        asigClientes = new ArrayList<>(_n_clientes);
        for (int i = 0; i < _n_clientes; ++i) {
            asigClientes.add(-1);
        }

        consumoCentrales = new ArrayList<>(_n_centrales);
        for (int i = 0; i < _n_centrales; ++i) {
            consumoCentrales.add(0.);
        }
    }

    public CentralEnergiaEstado(CentralEnergiaEstado estado) {
        asigClientes = new ArrayList<Integer>(estado.asigClientes);
        consumoCentrales = new ArrayList<Double>(estado.consumoCentrales);
    }

    /* ===== Funciones ===== */

    static public double distanciaEuclidea(int[] a, int[] b) {
        if (a.length != 2 || b.length != 2) {
            System.out.println("ERROR: El numero de posiciones en distanciaEuclidea tiene que ser = 2");
            return 0.;
        }

        double part1 = a[0] - b[0];
        double part2 = a[1] - b[1];
        return Math.sqrt(part1 * part1 + part2 * part2);
    }

    public double calcularPerdidaDistancia(int[] posCliente, int[] posCentral) {
        if (posCliente.length != 2 || posCentral.length != 2) {
            System.out.println("ERROR: El numero de posiciones en calcularPerdidaDistancia tiene que ser = 2");
            return 0.;
        }

        double distancia = distanciaEuclidea(posCliente, posCentral);

        if (distancia <= 10) return 0.0;
        else if (distancia > 10 && distancia <= 25) return 0.1;
        else if (distancia > 25 && distancia <= 50) return 0.2;
        else if (distancia > 50 && distancia <= 75) return 0.4;
        else return 0.6; // km >= 75
    }

    public boolean isGoalState() {
        return false;
    }

   public int getNumCentralesParadas(){
        int suma = 0;
        for(int i = 0; i < _n_centrales; ++i){
            double valor = consumoCentrales.get(i);
            if (valor == 0) ++suma;
        }
        return suma;
    }

    public double calculaBeneficio() {
        double ben = 0;
        for (int i = 0; i < _n_centrales; ++i) {
            Central centra = _centrales.get(i);
            double valor = consumoCentrales.get(i);
            if (centra.getTipo() == Central.CENTRALA) {
                if (valor == 0) ben = ben - 15000;
                else ben = ben - (centra.getProduccion() * 50 + 20000);
            } else if (centra.getTipo() == Central.CENTRALB) {
                if (valor == 0) ben = ben - 5000;
                else ben = ben - (centra.getProduccion() * 80 + 10000);
            } else if (centra.getTipo() == Central.CENTRALC) {
                if (valor == 0) ben = ben - 1500;
                else ben = ben - (centra.getProduccion() * 150 + 5000);
            }
        }

        for (int j = 0; j < _n_clientes; ++j) {
            Cliente cli = _clientes.get(j);
            int asignado = asigClientes.get(j);

            if (asignado == -1) ben = ben - cli.getConsumo() * 50;
            else {
                if (cli.getContrato() == Cliente.GARANTIZADO) {
                    if (cli.getTipo() == Cliente.CLIENTEXG) ben = ben + cli.getConsumo() * 400;
                    else if (cli.getTipo() == Cliente.CLIENTEMG) ben = ben + cli.getConsumo() * 500;
                    else ben = ben + cli.getConsumo() * 600;
                } else {
                    if (cli.getTipo() == Cliente.CLIENTEXG) ben = ben + cli.getConsumo() * 300;
                    else if (cli.getTipo() == Cliente.CLIENTEMG) ben = ben + cli.getConsumo() * 400;
                    else ben = ben + cli.getConsumo() * 500;
                }
            }
        }
        return ben;
    }

    public double calculaDistancia() {
        double sumaDist = 0.0;
        for (int idCli = 0; idCli < _n_clientes; ++idCli) {
            int idCentral = asigClientes.get(idCli);
            //El cliente está asignado a una central.
            if (idCentral != -1) {
                Central cen = _centrales.get(idCentral);
                Cliente cli = _clientes.get(idCli);
                int[] posCentral = {cen.getCoordX(), cen.getCoordY()};
                int[] posCliente = {cli.getCoordX(), cli.getCoordY()};
                double dist = distanciaEuclidea(posCliente, posCentral);
                sumaDist += dist;
            }
        }
        return sumaDist;
    }

    public int numClientesGarNoAsig() {
        int counter = 0;
        for (int i = 0; i < _n_clientes; ++i) {
            Cliente cl = _clientes.get(i);
            //El cliente es garantizado y no está asignado.
            if (cl.getContrato() == Cliente.GARANTIZADO && asigClientes.get(i) == -1) ++counter;
        }
        return counter;
    }

    public String todosGarAsig() {
        int clGarAsig = 0;
        for (int i = 0; i < _n_clientes; ++i) {
            Cliente cl = _clientes.get(i);
            if (cl.getContrato() == Cliente.GARANTIZADO && asigClientes.get(i) == -1) return "NO";
            else if (cl.getContrato() == Cliente.GARANTIZADO && asigClientes.get(i) != -1) ++clGarAsig;
        }
        return clGarAsig == totalCliGar ? "YES" : "NO";
    }

    public int contarCliGarAsig() {
        int counter = 0;
        for (int i = 0; i < _n_clientes; ++i) {
            Cliente cl = _clientes.get(i);
            if (cl.getContrato() == Cliente.GARANTIZADO && asigClientes.get(i) != -1) ++counter;
        }
        return counter;
    }

    public void imprimirEstado() {
        System.out.print("Clientes: ");
        for (int i = 0; i < _n_clientes; ++i) {
            String gar;
            if (_clientes.get(i).getContrato() == Cliente.GARANTIZADO) gar = "YES";
            else gar = "NO";
            System.out.print("{" + _clientes.get(i).getConsumo() + ", " + gar + "}");
        }
        System.out.print("\n");

        System.out.print("Centrales: ");
        for (int i = 0; i < _n_centrales; ++i) {
            System.out.print(_centrales.get(i).getProduccion() + " ");
        }
        System.out.print("\n");

        System.out.println(asigClientes);
        System.out.println(consumoCentrales + "\n");
    }

    public int contarClientesAsignados() {
        int contador = 0;
        for (int cl : asigClientes) {
            if (cl != -1) ++contador;
        }
        return contador;
    }

    /* ===== Generadores Solución Inicial ===== */

    public void generaSolucionGreedy() {
        // Ordenar clientes en base a garantizado y su consumo, de forma descendiente
        _clientes.sort(new Comparator<Cliente>() {
            @Override
            public int compare(Cliente c1, Cliente c2) {
                if (c1.getContrato() == Cliente.GARANTIZADO && c2.getContrato() == Cliente.NOGARANTIZADO) return -1;
                if (c1.getContrato() == Cliente.NOGARANTIZADO && c2.getContrato() == Cliente.GARANTIZADO) return 1;

                if (c1.getConsumo() > c2.getConsumo()) return -1;
                if (c1.getConsumo() == c2.getConsumo()) return 0;
                if (c1.getConsumo() < c2.getConsumo()) return 1;

                return 0;
            }
        });



        // Ordenar centrales en base a su producción, de forma descendiente
        _centrales.sort(new Comparator<Central>() {
            @Override
            public int compare(Central c1, Central c2) {
                if (c1.getProduccion() > c2.getProduccion()) return -1;
                if (c1.getProduccion() == c2.getProduccion()) return 0;
                if (c1.getProduccion() < c2.getProduccion()) return 1;

                return 0;
            }
        });

        // Recorrer los clientes ordenados
        for (int clienteId = 0; clienteId < _n_clientes; ++clienteId) {
            Cliente cliente = _clientes.get(clienteId);

            // Recorrer las centrales ordenadas
            for (int centralId = 0; centralId < _n_centrales; ++centralId) {
                Central central = _centrales.get(centralId);

                // Calcular el "consumo real", teniendo en cuenta la perdida de energia dada la distancia
                int[] posCliente = new int[]{cliente.getCoordX(), cliente.getCoordY()};
                int[] posCentral = new int[]{central.getCoordX(), central.getCoordY()};
                double consumoReal = cliente.getConsumo() + cliente.getConsumo() * calcularPerdidaDistancia(posCliente, posCentral);

                double consumoRestanteCentral = central.getProduccion() - consumoCentrales.get(centralId);

                if (consumoRestanteCentral - consumoReal >= 0) {
                    consumoCentrales.set(centralId, consumoCentrales.get(centralId) + consumoReal);
                    asigClientes.set(clienteId, centralId);
                    break;
                }
            }
        }
    }

    public void generaSolucionIntermedia() {
        // Asignar consumidores a la central más cercana (priorizando garantizados).
        // Si sobrepasa capacidad, segunda más cercana....
        _clientes.sort(new Comparator<Cliente>() {
            @Override
            public int compare(Cliente c1, Cliente c2) {
                if (c1.getContrato() == Cliente.GARANTIZADO && c2.getContrato() == Cliente.NOGARANTIZADO) return -1;
                if (c1.getContrato() == Cliente.NOGARANTIZADO && c2.getContrato() == Cliente.GARANTIZADO) return 1;

                if (c1.getConsumo() > c2.getConsumo()) return -1;
                if (c1.getConsumo() == c2.getConsumo()) return 0;
                if (c1.getConsumo() < c2.getConsumo()) return 1;

                return 0;
            }
        });

        // recorrer array de clientes y buscar la central más cercana al cliente i.
        for (int i = 0; i < _n_clientes; ++i) {
            int index_central = 0;
            Cliente cl = _clientes.get(i);
            Central cen = _centrales.get(index_central); // cogemos la primera como distancia mínima.
            int[] coordsCliente = {cl.getCoordX(), cl.getCoordY()};
            int[] coordsCentral = {cen.getCoordX(), cen.getCoordY()};
            double minDist = distanciaEuclidea(coordsCliente, coordsCentral);

            for (int j = 1; j < _n_centrales; ++j) {
                cen = _centrales.get(j);
                coordsCentral = new int[]{cen.getCoordX(), cen.getCoordY()};
                double dist = distanciaEuclidea(coordsCliente, coordsCentral);
                if (dist < minDist) {
                    minDist = dist;
                    index_central = j;
                }
            }

            // Hemos de tener en cuenta la pérdida de energia por transporte.
            int[] posCentral = {_centrales.get(index_central).getCoordX(), _centrales.get(index_central).getCoordY()};
            double consumoReal = cl.getConsumo() + cl.getConsumo() * calcularPerdidaDistancia(coordsCliente, posCentral);

            double produccionRestante = _centrales.get(index_central).getProduccion() - consumoCentrales.get(index_central);

            // Asignamos la central al cliente
            if (consumoReal <= produccionRestante) {
                consumoCentrales.set(index_central, consumoCentrales.get(index_central) + consumoReal);
                asigClientes.set(i, index_central);
            }
        }
    }

    public void generaSolucionNormal() {
        // Asignar los consumidores, garantizados primero, las centrales tal como llegan

        // Colocamos los garantizados primero
        _clientes.sort(new Comparator<Cliente>() {
            @Override
            public int compare(Cliente c1, Cliente c2) {
                if (c1.getContrato() == Cliente.GARANTIZADO && c2.getContrato() == Cliente.NOGARANTIZADO) return -1;
                else if (c1.getContrato() == Cliente.NOGARANTIZADO && c2.getContrato() == Cliente.GARANTIZADO) return 1;
                return -1;
            }
        });

        // Asignamos los clientes segun nos vayan viniendo las centrales
        int i = 0;
        int j = 0;
        while (j < _n_clientes && i < _centrales.size()) {
            Central cen = _centrales.get(i);
            Cliente cli = _clientes.get(j);
            int[] posCli = new int[]{cli.getCoordX(), cli.getCoordY()};
            int[] posCen = new int[]{cen.getCoordX(), cen.getCoordY()};
            double consumoCli = cli.getConsumo() + cli.getConsumo() * calcularPerdidaDistancia(posCli, posCen);

            double consumoRestanteLimitado = cen.getProduccion() - consumoCentrales.get(i);

            if (consumoRestanteLimitado - consumoCli >= 0) {
                consumoCentrales.set(i, consumoCentrales.get(i) + consumoCli);
                asigClientes.set(j, i);
                ++j;
            } else ++i;
        }
    }

    /* ===== Operadores ===== */

    public boolean asignar(int idCliente, int idCentral) {
        Cliente cliente = _clientes.get(idCliente);
        Central central = _centrales.get(idCentral);
        double consumoActualCentral = consumoCentrales.get(idCentral);

        int[] posCliente = new int[]{cliente.getCoordX(), cliente.getCoordY()};
        int[] posCentral = new int[]{central.getCoordX(), central.getCoordY()};
        double consumoRealCliente = cliente.getConsumo() + cliente.getConsumo() * calcularPerdidaDistancia(posCliente, posCentral);

        // El cliente no cabe en la central, por lo que no se puede asignar
        if (consumoActualCentral + consumoRealCliente > central.getProduccion()) return false;

        // Si cliente asignado, tenemos que restar el consumo a la central del cual lo quitamos
        if (asigClientes.get(idCliente) != -1) {
            int centralAsignada = asigClientes.get(idCliente);
            Central centralAsig = _centrales.get(centralAsignada);
            int[] posCentralAsig = new int[]{centralAsig.getCoordX(), centralAsig.getCoordY()};
            double consumoClienteAsig = cliente.getConsumo() + cliente.getConsumo() * calcularPerdidaDistancia(posCliente, posCentralAsig);
            consumoCentrales.set(centralAsignada, consumoCentrales.get(centralAsignada) - consumoClienteAsig);
        }
        asigClientes.set(idCliente, idCentral);
        consumoCentrales.set(idCentral, consumoCentrales.get(idCentral) + consumoRealCliente);
        return true;
    }

    public boolean desasignar(int idCliente) {
        int asignado = asigClientes.get(idCliente);
        if (asignado == -1) {
            return false;
        }

        Cliente cliente = _clientes.get(idCliente);
        Central central = _centrales.get(asignado);
        double consumoActualCentral = consumoCentrales.get(asignado);

        int[] posCliente = new int[]{cliente.getCoordX(), cliente.getCoordY()};
        int[] posCentral = new int[]{central.getCoordX(), central.getCoordY()};
        double consumoRealCliente = cliente.getConsumo() + cliente.getConsumo() * calcularPerdidaDistancia(posCliente, posCentral);

        consumoCentrales.set(asignado, consumoActualCentral - consumoRealCliente);
        asigClientes.set(idCliente, -1);
        return true;
    }

    public boolean volcar(int idCen1, int idCen2) {
        // INTERCAMBIAR TODOS LOS CONSUMIDORES
        ArrayList<Integer> clientesCentral1 = new ArrayList<>();
        ArrayList<Integer> clientesCentral2 = new ArrayList<>();

        for (int i = 0; i < _n_clientes; ++i) {
            int asignado = asigClientes.get(i);
            if (asignado == idCen1) {
                clientesCentral1.add(i);
                desasignar(i);
            } else if (asignado == idCen2) {
                clientesCentral2.add(i);
                desasignar(i);
            }
        }

        for (int idCliente : clientesCentral1) {
            if (!asignar(idCliente, idCen2)) {
                return false;
            }
        }
        for (int idCliente : clientesCentral2) {
            if (!asignar(idCliente, idCen1)) {
                return false;
            }
        }

        return true;
    }

    public boolean intercambiar(int idCli1, int idCli2) {
        int idCen1 = asigClientes.get(idCli1);
        int idCen2 = asigClientes.get(idCli2);

        if (idCen1 == -1 && idCen2 != -1 && (_clientes.get(idCli2).getContrato() != Cliente.GARANTIZADO)) {
            return desasignar(idCli2) && asignar(idCli1, idCen2);
        } else if (idCen1 != -1 && idCen2 == -1 && (_clientes.get(idCli1).getContrato() != Cliente.GARANTIZADO)) {
            return desasignar(idCli1) && asignar(idCli2, idCen1);
        } else if (idCen1 != idCen2) {
            return desasignar(idCli1) && desasignar(idCli2) && asignar(idCli1, idCen2) && asignar(idCli2, idCen1);
        }
        return false;
    }
}

