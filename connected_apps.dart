import 'package:flutter/material.dart';

class ConnectedAppsPage extends StatefulWidget {
  const ConnectedAppsPage({Key? key}) : super(key: key);

  @override
  _ConnectedAppsPageState createState() => _ConnectedAppsPageState();
}

class _ConnectedAppsPageState extends State<ConnectedAppsPage> {
  final List<Map<String, dynamic>> _connectedApps = [
    {
      'name': 'Apple Health',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'connected': true,
      'permissions': ['Read cycle data', 'Read mood data', 'Read activity data'],
      'lastSync': 'Today, 7:30 AM',
    },
    {
      'name': 'Google Fit',
      'icon': Icons.directions_run,
      'color': Colors.blue,
      'connected': true,
      'permissions': ['Read cycle data', 'Read health metrics'],
      'lastSync': 'Yesterday, 8:45 PM',
    },
    {
      'name': 'Samsung Health',
      'icon': Icons.monitor_heart,
      'color': Colors.green,
      'connected': false,
      'permissions': [],
      'lastSync': 'Never',
    },
    {
      'name': 'Fitbit',
      'icon': Icons.watch,
      'color': Colors.indigo,
      'connected': false,
      'permissions': [],
      'lastSync': 'Never',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> connectedApps = _connectedApps.where((app) => app['connected']).toList();
    final List<Map<String, dynamic>> availableApps = _connectedApps.where((app) => !app['connected']).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Apps'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF9C27B0)),
                          SizedBox(width: 8),
                          Text(
                            'Apps & Services',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connect SheTrack with other apps and services to sync your health data and get a complete picture of your well-being.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Connected apps section
              if (connectedApps.isNotEmpty) ...[
                const Text(
                  'CONNECTED APPS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: List.generate(
                      connectedApps.length,
                      (index) {
                        final app = connectedApps[index];
                        return Column(
                          children: [
                            _buildConnectedAppTile(app),
                            if (index < connectedApps.length - 1) const Divider(height: 0),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Available apps to connect
              const Text(
                'AVAILABLE TO CONNECT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: List.generate(
                    availableApps.length,
                    (index) {
                      final app = availableApps[index];
                      return Column(
                        children: [
                          _buildAvailableAppTile(app),
                          if (index < availableApps.length - 1) const Divider(height: 0),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildConnectedAppTile(Map<String, dynamic> app) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: app['color'].withOpacity(0.2),
        child: Icon(app['icon'], color: app['color']),
      ),
      title: Text(
        app['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('Last synced: ${app['lastSync']}'),
          const SizedBox(height: 2),
          Text('${app['permissions'].length} permissions granted'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => _showAppDetailsDialog(app),
      ),
    );
  }
  
  Widget _buildAvailableAppTile(Map<String, dynamic> app) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: app['color'].withOpacity(0.2),
        child: Icon(app['icon'], color: app['color']),
      ),
      title: Text(
        app['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Connect to sync your health data'),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9C27B0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: () => _connectApp(app),
        child: const Text('Connect'),
      ),
    );
  }
  
  void _showAppDetailsDialog(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(app['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Permissions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              app['permissions'].length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(app['permissions'][index]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Last synced: ${app['lastSync']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _disconnectApp(app);
              Navigator.pop(context);
            },
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
  
  void _connectApp(Map<String, dynamic> app) {
    setState(() {
      final index = _connectedApps.indexWhere((item) => item['name'] == app['name']);
      if (index != -1) {
        _connectedApps[index]['connected'] = true;
        _connectedApps[index]['lastSync'] = 'Just now';
        _connectedApps[index]['permissions'] = ['Read cycle data', 'Read health metrics'];
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${app['name']} connected successfully'),
        backgroundColor: const Color(0xFF9C27B0),
      ),
    );
  }
  
  void _disconnectApp(Map<String, dynamic> app) {
    setState(() {
      final index = _connectedApps.indexWhere((item) => item['name'] == app['name']);
      if (index != -1) {
        _connectedApps[index]['connected'] = false;
        _connectedApps[index]['permissions'] = [];
        _connectedApps[index]['lastSync'] = 'Never';
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${app['name']} disconnected'),
        backgroundColor: Colors.red,
      ),
    );
  }
}