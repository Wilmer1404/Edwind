import { useEffect, useState, useMemo } from 'react'
import { apiClient } from '@/lib/api-client'
import { ActionLog } from '@/types'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { toast } from 'sonner'
import {
  ShieldCheck,
  History,
  Filter,
  Search,
  Calendar,
  User,
  Activity,
  FileText,
  Truck,
  Building2,
  Download,
  RefreshCw,
  Laptop,
  Eye,
  AlertTriangle,
  RotateCcw,
  ChevronLeft,
  ChevronRight,
  Database,
  Layers,
  Sparkles
} from 'lucide-react'

export function BitacoraAuditoria() {
  const [logs, setLogs] = useState<ActionLog[]>([])
  const [loading, setLoading] = useState(false)
  const [refreshing, setRefreshing] = useState(false)
  const [selectedLog, setSelectedLog] = useState<ActionLog | null>(null)
  const [detailOpen, setDetailOpen] = useState(false)

  // Paginación del servidor
  const [page, setPage] = useState(1)
  const [totalPages, setTotalPages] = useState(1)
  const [totalRecords, setTotalRecords] = useState(0)
  const limit = 15

  // Filtros visuales
  const [userFilter, setUserFilter] = useState('')
  const [actionFilter, setActionFilter] = useState<string>('todos')
  const [entityFilter, setEntityFilter] = useState<string>('todos')
  const [dateFilter, setDateFilter] = useState<string>('')
  const [quickDatePreset, setQuickDatePreset] = useState<'all' | 'today' | 'week' | 'month'>('all')

  useEffect(() => {
    loadAuditoria()
  }, [page, actionFilter, entityFilter])

  async function loadAuditoria(isManualRefresh = false) {
    try {
      if (isManualRefresh) setRefreshing(true)
      else setLoading(true)

      const params: Record<string, any> = {
        page,
        limit,
      }

      if (actionFilter !== 'todos') {
        params.accion = actionFilter
      }
      if (entityFilter !== 'todos') {
        params.entidad = entityFilter
      }

      const res = await apiClient.listAuditoria(params)
      if (res && res.success && res.data) {
        const dataList: ActionLog[] = res.data.data || []
        setLogs(dataList)
        if (res.data.pagination) {
          setTotalPages(res.data.pagination.pages || 1)
          setTotalRecords(res.data.pagination.total || dataList.length)
        } else {
          setTotalRecords(dataList.length)
        }
      } else {
        setLogs([])
      }
    } catch (err) {
      console.error('Error al cargar la bitácora de auditoría:', err)
      toast.error('No se pudo cargar la bitácora de auditoría')
    } finally {
      setLoading(false)
      setRefreshing(false)
    }
  }

  // Filtrado local reactivo para Usuario y Fechas (sobre los registros activos o búsqueda combinada)
  const filteredLogs = useMemo(() => {
    return logs.filter((log) => {
      // Filtro por Usuario (Nombre, Email o ID)
      if (userFilter.trim() !== '') {
        const query = userFilter.toLowerCase().trim()
        const matchName = log.usuario_nombre?.toLowerCase().includes(query)
        const matchEmail = log.email?.toLowerCase().includes(query)
        const matchUserId = String(log.user_id).includes(query)
        if (!matchName && !matchEmail && !matchUserId) return false
      }

      // Filtro por Fecha específica
      if (dateFilter) {
        if (!log.created_at || !log.created_at.startsWith(dateFilter)) {
          return false
        }
      }

      // Filtro por Quick Presets de fecha
      if (quickDatePreset !== 'all' && log.created_at) {
        const logDate = new Date(log.created_at.replace(' ', 'T'))
        const now = new Date()
        if (quickDatePreset === 'today') {
          const isToday =
            logDate.getDate() === now.getDate() &&
            logDate.getMonth() === now.getMonth() &&
            logDate.getFullYear() === now.getFullYear()
          if (!isToday) return false
        } else if (quickDatePreset === 'week') {
          const diffDays = (now.getTime() - logDate.getTime()) / (1000 * 3600 * 24)
          if (diffDays > 7) return false
        } else if (quickDatePreset === 'month') {
          const diffDays = (now.getTime() - logDate.getTime()) / (1000 * 3600 * 24)
          if (diffDays > 30) return false
        }
      }

      return true
    })
  }, [logs, userFilter, dateFilter, quickDatePreset])

  // Métricas ejecutivas de la bitácora
  const metrics = useMemo(() => {
    const total = totalRecords
    const uniqueUsers = new Set(logs.map((l) => l.user_id)).size
    const criticalActions = logs.filter(
      (l) =>
        l.accion.toUpperCase().includes('ELIMIN') ||
        l.accion.toUpperCase().includes('REVOC') ||
        l.accion.toUpperCase().includes('BLOQUE')
    ).length
    const todayLogs = logs.filter((l) => {
      if (!l.created_at) return false
      const d = new Date(l.created_at.replace(' ', 'T'))
      const now = new Date()
      return (
        d.getDate() === now.getDate() &&
        d.getMonth() === now.getMonth() &&
        d.getFullYear() === now.getFullYear()
      )
    }).length

    return { total, uniqueUsers, criticalActions, todayLogs }
  }, [logs, totalRecords])

  function handleResetFilters() {
    setUserFilter('')
    setActionFilter('todos')
    setEntityFilter('todos')
    setDateFilter('')
    setQuickDatePreset('all')
    setPage(1)
  }

  function exportToCsv() {
    if (filteredLogs.length === 0) {
      toast.warning('No hay datos en la bitácora para exportar')
      return
    }

    const headers = ['ID', 'Fecha/Hora', 'Usuario', 'Email', 'Acción', 'Entidad', 'ID Entidad', 'IP', 'Detalles']
    const csvRows = [
      headers.join(','),
      ...filteredLogs.map((l) =>
        [
          l.id,
          `"${l.created_at}"`,
          `"${l.usuario_nombre || 'Sistema'}"`,
          `"${l.email || '-'}"`,
          `"${l.accion}"`,
          `"${l.entidad}"`,
          l.entidad_id ?? '',
          `"${l.ip_address || '-'}"`,
          `"${(l.descripcion || '').replace(/"/g, '""')}"`,
        ].join(',')
      ),
    ]

    const blob = new Blob([csvRows.join('\n')], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', `bitacora_auditoria_marcona_${new Date().toISOString().slice(0, 10)}.csv`)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    toast.success('Bitácora exportada en formato CSV correctamente')
  }

  function getActionBadge(action: string) {
    const act = (action || '').toUpperCase()
    if (act.includes('CREAR') || act.includes('INSERT') || act.includes('REGISTR')) {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
          <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
          {action}
        </span>
      )
    }
    if (act.includes('ACTUALIZ') || act.includes('MODIFIC') || act.includes('EDIT')) {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-sky-50 text-sky-700 border border-sky-200">
          <span className="w-1.5 h-1.5 rounded-full bg-sky-500" />
          {action}
        </span>
      )
    }
    if (act.includes('ELIMIN') || act.includes('REVOC') || act.includes('BLOQUE')) {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-rose-50 text-rose-700 border border-rose-200">
          <span className="w-1.5 h-1.5 rounded-full bg-rose-500" />
          {action}
        </span>
      )
    }
    if (act.includes('RENOV')) {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 border border-indigo-200">
          <span className="w-1.5 h-1.5 rounded-full bg-indigo-500" />
          {action}
        </span>
      )
    }
    if (act.includes('LOGIN') || act.includes('AUTH') || act.includes('ACCESO')) {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-purple-50 text-purple-700 border border-purple-200">
          <span className="w-1.5 h-1.5 rounded-full bg-purple-500" />
          {action}
        </span>
      )
    }
    return (
      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-700 border border-slate-200">
        <span className="w-1.5 h-1.5 rounded-full bg-slate-400" />
        {action}
      </span>
    )
  }

  function getEntityIcon(entity: string) {
    const ent = (entity || '').toLowerCase()
    if (ent.includes('vehic')) return <Truck className="w-3.5 h-3.5 text-blue-600" />
    if (ent.includes('permis') || ent.includes('tuc')) return <FileText className="w-3.5 h-3.5 text-indigo-600" />
    if (ent.includes('empresa') || ent.includes('compan')) return <Building2 className="w-3.5 h-3.5 text-amber-600" />
    if (ent.includes('conductor') || ent.includes('chofer') || ent.includes('driver')) return <User className="w-3.5 h-3.5 text-emerald-600" />
    if (ent.includes('usuario') || ent.includes('user')) return <ShieldCheck className="w-3.5 h-3.5 text-violet-600" />
    return <Database className="w-3.5 h-3.5 text-slate-500" />
  }

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      {/* Encabezado Superior con Identidad Institucional */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
        <div className="space-y-1.5">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-slate-100 text-slate-700 border border-slate-200">
            <ShieldCheck className="w-3.5 h-3.5 text-[#0A2342]" />
            <span>Seguridad Institucional &bull; Mapeo ORM JPA &bull; MTC Marcona</span>
          </div>
          <h1 className="text-2xl font-extrabold text-slate-900 tracking-tight flex items-center gap-3">
            <History className="w-7 h-7 text-[#0A2342]" />
            Bitácora Visual de Auditoría
          </h1>
          <p className="text-sm text-slate-500 max-w-2xl">
            Trazabilidad completa de operaciones transaccionales, auditoría inmutable de accesos y mutaciones
            en el parque vehicular y permisos de circulación.
          </p>
        </div>

        <div className="flex items-center gap-3 shrink-0">
          <Button
            variant="outline"
            size="sm"
            onClick={() => loadAuditoria(true)}
            disabled={refreshing || loading}
            className="border-slate-200 hover:bg-slate-50 text-slate-700 font-semibold shadow-xs"
          >
            <RefreshCw className={`w-4 h-4 mr-2 ${refreshing ? 'animate-spin text-[#0A2342]' : ''}`} />
            Sincronizar
          </Button>

          <Button
            size="sm"
            onClick={exportToCsv}
            className="bg-[#0A2342] hover:bg-[#0c2f5a] text-white font-semibold shadow-sm"
          >
            <Download className="w-4 h-4 mr-2" />
            Exportar CSV
          </Button>
        </div>
      </div>

      {/* Tarjetas de Métricas Ejecutivas */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card className="border-slate-200/80 shadow-xs hover:border-slate-300 transition-all">
          <CardContent className="p-5 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Total Transacciones</p>
              <h3 className="text-2xl font-black text-slate-900 mt-1">{metrics.total.toLocaleString()}</h3>
              <p className="text-[11px] text-emerald-600 font-medium mt-1 flex items-center gap-1">
                <Sparkles className="w-3 h-3" /> Eventos en base de datos
              </p>
            </div>
            <div className="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600">
              <Database className="w-6 h-6" />
            </div>
          </CardContent>
        </Card>

        <Card className="border-slate-200/80 shadow-xs hover:border-slate-300 transition-all">
          <CardContent className="p-5 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Usuarios Actores</p>
              <h3 className="text-2xl font-black text-slate-900 mt-1">{metrics.uniqueUsers}</h3>
              <p className="text-[11px] text-slate-500 font-medium mt-1">Operadores y Administradores</p>
            </div>
            <div className="w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center text-indigo-600">
              <User className="w-6 h-6" />
            </div>
          </CardContent>
        </Card>

        <Card className="border-slate-200/80 shadow-xs hover:border-slate-300 transition-all">
          <CardContent className="p-5 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Acciones Críticas</p>
              <h3 className="text-2xl font-black text-rose-600 mt-1">{metrics.criticalActions}</h3>
              <p className="text-[11px] text-rose-500 font-medium mt-1">Revocaciones o eliminaciones</p>
            </div>
            <div className="w-12 h-12 rounded-xl bg-rose-50 flex items-center justify-center text-rose-600">
              <AlertTriangle className="w-6 h-6" />
            </div>
          </CardContent>
        </Card>

        <Card className="border-slate-200/80 shadow-xs hover:border-slate-300 transition-all">
          <CardContent className="p-5 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Actividad Hoy</p>
              <h3 className="text-2xl font-black text-emerald-600 mt-1">{metrics.todayLogs}</h3>
              <p className="text-[11px] text-emerald-600 font-medium mt-1">Registrados en la fecha actual</p>
            </div>
            <div className="w-12 h-12 rounded-xl bg-emerald-50 flex items-center justify-center text-emerald-600">
              <Activity className="w-6 h-6" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Barra de Filtros Visuales Avanzados */}
      <Card className="border-slate-200/80 shadow-xs">
        <CardContent className="p-5 space-y-4">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-100 pb-3">
            <div className="flex items-center gap-2">
              <Filter className="w-4 h-4 text-[#0A2342]" />
              <span className="text-sm font-bold text-slate-800">Filtros de Trazabilidad</span>
              <span className="text-xs text-slate-400 font-normal">
                ({filteredLogs.length} registros visibles)
              </span>
            </div>

            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-500 font-medium">Rango rápido:</span>
              <div className="inline-flex rounded-lg border border-slate-200 p-0.5 bg-slate-50 text-xs">
                <button
                  type="button"
                  onClick={() => setQuickDatePreset('all')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition-colors ${
                    quickDatePreset === 'all' ? 'bg-white shadow-xs text-slate-900' : 'text-slate-500 hover:text-slate-900'
                  }`}
                >
                  Todos
                </button>
                <button
                  type="button"
                  onClick={() => setQuickDatePreset('today')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition-colors ${
                    quickDatePreset === 'today' ? 'bg-white shadow-xs text-slate-900' : 'text-slate-500 hover:text-slate-900'
                  }`}
                >
                  Hoy
                </button>
                <button
                  type="button"
                  onClick={() => setQuickDatePreset('week')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition-colors ${
                    quickDatePreset === 'week' ? 'bg-white shadow-xs text-slate-900' : 'text-slate-500 hover:text-slate-900'
                  }`}
                >
                  7 días
                </button>
                <button
                  type="button"
                  onClick={() => setQuickDatePreset('month')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition-colors ${
                    quickDatePreset === 'month' ? 'bg-white shadow-xs text-slate-900' : 'text-slate-500 hover:text-slate-900'
                  }`}
                >
                  30 días
                </button>
              </div>

              {(userFilter || actionFilter !== 'todos' || entityFilter !== 'todos' || dateFilter || quickDatePreset !== 'all') && (
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={handleResetFilters}
                  className="text-xs text-slate-500 hover:text-slate-800 h-8"
                >
                  <RotateCcw className="w-3.5 h-3.5 mr-1" />
                  Limpiar
                </Button>
              )}
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
            {/* Filtro por Usuario */}
            <div className="relative">
              <label className="text-xs font-semibold text-slate-600 mb-1 block">
                Usuario (Actor)
              </label>
              <div className="relative">
                <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <Input
                  type="text"
                  placeholder="Buscar por nombre, email o ID..."
                  value={userFilter}
                  onChange={(e) => setUserFilter(e.target.value)}
                  className="pl-9 bg-white border-slate-200 text-sm focus:ring-[#0A2342]"
                />
              </div>
            </div>

            {/* Filtro por Acción */}
            <div>
              <label className="text-xs font-semibold text-slate-600 mb-1 block">
                Acción Realizada
              </label>
              <Select value={actionFilter} onValueChange={(val) => { setActionFilter(val); setPage(1); }}>
                <SelectTrigger className="bg-white border-slate-200 text-sm">
                  <SelectValue placeholder="Seleccionar acción" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="todos">Todas las acciones</SelectItem>
                  <SelectItem value="CREAR">CREAR / REGISTRAR</SelectItem>
                  <SelectItem value="ACTUALIZAR">ACTUALIZAR / EDITAR</SelectItem>
                  <SelectItem value="ELIMINAR">ELIMINAR / BORRAR</SelectItem>
                  <SelectItem value="REVOCAR">REVOCAR PERMISO</SelectItem>
                  <SelectItem value="RENOVAR">RENOVAR TUC</SelectItem>
                  <SelectItem value="LOGIN">INICIO DE SESIÓN</SelectItem>
                  <SelectItem value="VERIFICAR">CONSULTA FISCALIZADOR</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* Filtro por Entidad */}
            <div>
              <label className="text-xs font-semibold text-slate-600 mb-1 block">
                Entidad Afectada
              </label>
              <Select value={entityFilter} onValueChange={(val) => { setEntityFilter(val); setPage(1); }}>
                <SelectTrigger className="bg-white border-slate-200 text-sm">
                  <SelectValue placeholder="Seleccionar entidad" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="todos">Todas las entidades</SelectItem>
                  <SelectItem value="vehiculo">Vehículo</SelectItem>
                  <SelectItem value="permiso">Permiso (TUC)</SelectItem>
                  <SelectItem value="empresa">Empresa</SelectItem>
                  <SelectItem value="conductor">Conductor</SelectItem>
                  <SelectItem value="usuario">Usuario</SelectItem>
                  <SelectItem value="asignacion">Asignación Vehicular</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* Filtro por Fecha Específica */}
            <div>
              <label className="text-xs font-semibold text-slate-600 mb-1 block">
                Fecha Específica
              </label>
              <div className="relative">
                <Calendar className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
                <Input
                  type="date"
                  value={dateFilter}
                  onChange={(e) => setDateFilter(e.target.value)}
                  className="pl-9 bg-white border-slate-200 text-sm focus:ring-[#0A2342]"
                />
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tabla Principal: Bitácora Detallada */}
      <Card className="border-slate-200/80 shadow-xs overflow-hidden">
        <div className="p-4 bg-slate-50/80 border-b border-slate-200 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Layers className="w-4 h-4 text-[#0A2342]" />
            <span className="font-bold text-slate-900 text-sm">Registros de Bitácora</span>
            <span className="text-xs font-semibold bg-slate-200/80 text-slate-700 px-2 py-0.5 rounded-full">
              Página {page} de {totalPages || 1}
            </span>
          </div>
          <span className="text-xs text-slate-500 font-medium">
            Total en base de datos: <strong className="text-slate-800">{totalRecords}</strong> eventos
          </span>
        </div>

        <div className="overflow-x-auto">
          <Table>
            <TableHeader className="bg-slate-100/60">
              <TableRow className="hover:bg-transparent border-slate-200">
                <TableHead className="w-[170px] text-xs font-bold text-slate-700 uppercase">
                  <div className="flex items-center gap-1.5">
                    <Calendar className="w-3.5 h-3.5 text-slate-400" />
                    Fecha / Hora
                  </div>
                </TableHead>
                <TableHead className="w-[220px] text-xs font-bold text-slate-700 uppercase">
                  <div className="flex items-center gap-1.5">
                    <User className="w-3.5 h-3.5 text-slate-400" />
                    Usuario (Actor)
                  </div>
                </TableHead>
                <TableHead className="w-[160px] text-xs font-bold text-slate-700 uppercase">
                  <div className="flex items-center gap-1.5">
                    <Activity className="w-3.5 h-3.5 text-slate-400" />
                    Acción Realizada
                  </div>
                </TableHead>
                <TableHead className="w-[160px] text-xs font-bold text-slate-700 uppercase">
                  <div className="flex items-center gap-1.5">
                    <Database className="w-3.5 h-3.5 text-slate-400" />
                    Entidad Afectada
                  </div>
                </TableHead>
                <TableHead className="w-[130px] text-xs font-bold text-slate-700 uppercase">
                  <div className="flex items-center gap-1.5">
                    <Laptop className="w-3.5 h-3.5 text-slate-400" />
                    Dirección IP
                  </div>
                </TableHead>
                <TableHead className="text-xs font-bold text-slate-700 uppercase">
                  Detalles Operativos
                </TableHead>
                <TableHead className="w-[80px] text-center text-xs font-bold text-slate-700 uppercase">
                  Ver
                </TableHead>
              </TableRow>
            </TableHeader>

            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={7} className="h-48 text-center">
                    <div className="flex flex-col items-center justify-center gap-2 text-slate-500">
                      <RefreshCw className="w-6 h-6 animate-spin text-[#0A2342]" />
                      <p className="text-sm font-semibold">Cargando registros de auditoría...</p>
                    </div>
                  </TableCell>
                </TableRow>
              ) : filteredLogs.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="h-48 text-center">
                    <div className="flex flex-col items-center justify-center gap-2 text-slate-400">
                      <ShieldCheck className="w-10 h-10 stroke-[1.5] text-slate-300" />
                      <p className="text-sm font-semibold text-slate-700">No se encontraron eventos en la bitácora</p>
                      <p className="text-xs text-slate-400 max-w-sm">
                        Intenta ajustar los filtros de búsqueda o sincroniza para verificar nuevas transacciones.
                      </p>
                      <Button variant="outline" size="sm" onClick={handleResetFilters} className="mt-2 text-xs">
                        Restablecer filtros
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ) : (
                filteredLogs.map((log) => {
                  const initials = (log.usuario_nombre || 'Sistema')
                    .split(' ')
                    .map((n) => n[0])
                    .slice(0, 2)
                    .join('')
                    .toUpperCase()

                  return (
                    <TableRow
                      key={log.id}
                      className="hover:bg-slate-50/80 transition-colors border-slate-100 group"
                    >
                      {/* Fecha / Hora */}
                      <TableCell className="align-middle">
                        <div className="flex flex-col">
                          <span className="font-semibold text-xs text-slate-800">
                            {log.created_at ? log.created_at.split(' ')[0] : '-'}
                          </span>
                          <span className="text-[11px] font-mono text-slate-500">
                            {log.created_at ? log.created_at.split(' ')[1] || '' : ''}
                          </span>
                        </div>
                      </TableCell>

                      {/* Usuario (Actor) */}
                      <TableCell className="align-middle">
                        <div className="flex items-center gap-2.5">
                          <Avatar className="h-8 w-8 bg-[#0A2342] text-white text-[11px] font-bold">
                            <AvatarFallback className="bg-[#0A2342] text-white">
                              {initials}
                            </AvatarFallback>
                          </Avatar>
                          <div className="flex flex-col min-w-0">
                            <span className="text-xs font-bold text-slate-900 truncate">
                              {log.usuario_nombre || 'Sistema Automatizado'}
                            </span>
                            <span className="text-[11px] text-slate-400 truncate">
                              {log.email || 'sistema@marcona.gob.pe'}
                            </span>
                          </div>
                        </div>
                      </TableCell>

                      {/* Acción Realizada */}
                      <TableCell className="align-middle">
                        {getActionBadge(log.accion)}
                      </TableCell>

                      {/* Entidad Afectada */}
                      <TableCell className="align-middle">
                        <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-medium bg-slate-100/90 text-slate-800 border border-slate-200/60">
                          {getEntityIcon(log.entidad)}
                          <span className="capitalize">{log.entidad}</span>
                          {log.entidad_id ? (
                            <span className="font-mono text-[10px] text-slate-500 font-semibold">
                              #{log.entidad_id}
                            </span>
                          ) : null}
                        </div>
                      </TableCell>

                      {/* Dirección IP */}
                      <TableCell className="align-middle">
                        <span className="font-mono text-xs bg-slate-100 text-slate-700 px-2 py-0.5 rounded border border-slate-200">
                          {log.ip_address || '127.0.0.1'}
                        </span>
                      </TableCell>

                      {/* Detalles Operativos */}
                      <TableCell className="align-middle max-w-xs">
                        <p className="text-xs text-slate-600 truncate font-normal" title={log.descripcion || ''}>
                          {log.descripcion || 'Sin descripción adicional registrada'}
                        </p>
                      </TableCell>

                      {/* Botón Ver Detalle */}
                      <TableCell className="align-middle text-center">
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => {
                            setSelectedLog(log)
                            setDetailOpen(true)
                          }}
                          className="h-8 w-8 p-0 text-slate-400 hover:text-slate-800 hover:bg-slate-100"
                        >
                          <Eye className="w-4 h-4" />
                        </Button>
                      </TableCell>
                    </TableRow>
                  )
                })
              )}
            </TableBody>
          </Table>
        </div>

        {/* Paginación Inferior */}
        <div className="p-4 bg-white border-t border-slate-200 flex flex-col sm:flex-row items-center justify-between gap-3 text-xs text-slate-500">
          <div>
            Mostrando <strong className="text-slate-800">{filteredLogs.length}</strong> de{' '}
            <strong className="text-slate-800">{totalRecords}</strong> registros
          </div>

          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => setPage((prev) => Math.max(1, prev - 1))}
              disabled={page <= 1 || loading}
              className="h-8 px-3 text-xs border-slate-200"
            >
              <ChevronLeft className="w-3.5 h-3.5 mr-1" />
              Anterior
            </Button>

            <span className="font-semibold text-slate-700 px-2">
              {page} / {totalPages || 1}
            </span>

            <Button
              variant="outline"
              size="sm"
              onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
              disabled={page >= totalPages || loading}
              className="h-8 px-3 text-xs border-slate-200"
            >
              Siguiente
              <ChevronRight className="w-3.5 h-3.5 ml-1" />
            </Button>
          </div>
        </div>
      </Card>

      {/* Modal Detallado de Inspección de Auditoría */}
      <Dialog open={detailOpen} onOpenChange={setDetailOpen}>
        <DialogContent className="max-w-xl">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-slate-900">
              <ShieldCheck className="w-5 h-5 text-[#0A2342]" />
              Detalle del Evento de Bitácora
            </DialogTitle>
            <DialogDescription className="text-xs text-slate-500">
              Registro inmutable de trazabilidad transaccional generado por el sistema.
            </DialogDescription>
          </DialogHeader>

          {selectedLog && (
            <div className="space-y-4 text-xs mt-2">
              <div className="grid grid-cols-2 gap-3 bg-slate-50 p-4 rounded-xl border border-slate-200">
                <div>
                  <span className="text-[11px] font-semibold text-slate-400 block uppercase">ID Auditoría</span>
                  <span className="font-mono font-bold text-slate-900 text-sm">#{selectedLog.id}</span>
                </div>
                <div>
                  <span className="text-[11px] font-semibold text-slate-400 block uppercase">Fecha y Hora</span>
                  <span className="font-semibold text-slate-800">{selectedLog.created_at}</span>
                </div>
                <div>
                  <span className="text-[11px] font-semibold text-slate-400 block uppercase">Usuario Actor</span>
                  <span className="font-bold text-slate-900 block">{selectedLog.usuario_nombre || 'Sistema'}</span>
                  <span className="text-[10px] text-slate-500">{selectedLog.email}</span>
                </div>
                <div>
                  <span className="text-[11px] font-semibold text-slate-400 block uppercase">IP de Origen</span>
                  <span className="font-mono bg-white px-2 py-0.5 rounded border border-slate-200 inline-block text-slate-800 font-semibold">
                    {selectedLog.ip_address || '127.0.0.1'}
                  </span>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="p-3 bg-white rounded-lg border border-slate-200">
                  <span className="text-[11px] font-semibold text-slate-400 block uppercase">Acción Transaccional</span>
                  <div className="mt-1">{getActionBadge(selectedLog.accion)}</div>
                </div>
                <div className="p-3 bg-white rounded-lg border border-slate-200">
                  <span className="text-[11px] font-semibold text-slate-400 block uppercase">Entidad Afectada</span>
                  <div className="flex items-center gap-1.5 mt-1 font-semibold text-slate-800">
                    {getEntityIcon(selectedLog.entidad)}
                    <span className="capitalize">{selectedLog.entidad}</span>
                    {selectedLog.entidad_id && (
                      <span className="font-mono text-xs text-blue-600 bg-blue-50 px-1.5 py-0.5 rounded">
                        ID: {selectedLog.entidad_id}
                      </span>
                    )}
                  </div>
                </div>
              </div>

              <div className="p-4 bg-slate-50 rounded-xl border border-slate-200">
                <span className="text-[11px] font-semibold text-slate-500 block uppercase mb-1">
                  Descripción Completa del Registro
                </span>
                <p className="text-slate-800 leading-relaxed font-mono bg-white p-3 rounded-lg border border-slate-200 text-xs">
                  {selectedLog.descripcion || 'Sin descripción adicional para este registro.'}
                </p>
              </div>

              <div className="flex items-center justify-between text-[11px] text-slate-400 border-t border-slate-100 pt-3">
                <div className="flex items-center gap-1.5">
                  <ShieldCheck className="w-4 h-4 text-emerald-600" />
                  <span className="text-emerald-700 font-semibold">Certificación de Integridad MTC Marcona</span>
                </div>
                <span className="font-mono">User ID: #{selectedLog.user_id}</span>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}
export default BitacoraAuditoria
